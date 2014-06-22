class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  has_many :uploaded_files
  has_many :user_charges

  before_create :create_stripe_customer
  after_save :update_stripe_customer

  def create_stripe_customer
    self.stripe_customer_token = Stripe::Customer.create({email: email})["id"]
  end

  def stripe_customer
    if !stripe_customer_token_valid?
      create_stripe_customer
      self.save
    end
    Stripe::Customer.retrieve stripe_customer_token
  end

  def update_stripe_customer
    c = self.stripe_customer
    c["email"] = email && c.save if c["email"] != email
  end

  def stripe_customer_token_valid?
    stripe_customer_token.present?
  end

  def payment_methods
    stripe_customer.cards.all
  end

  def payment_history
    Stripe::Charge.all(customer: stripe_customer_token)
  end

  def self.charge_users
    find_charge_worthy_users.each do |user|
      period = user.unpaid_request_payable_period
      user.new_charge user.current_final_charge(true), period[:start], period[:end]
    end
  end

  def self.find_charge_worthy_users
    file_ids = FileRequest
      .where(["end_date < ? AND user_charge_id IS NULL", Date.today.at_beginning_of_month])
      .pluck(:uploaded_file_id).uniq
    user_ids = UploadedFile.where(id: file_ids).pluck(:user_id).uniq
    #User.where(id: user_ids).map {|u| u if u.current_final_charge(true) >= MINIMUM_VALID_CHARGE }.compact
    User.where(id: user_ids, active: true, active_payments: true)
  end

  def new_charge amount, start_date, end_date
    charge = UserCharge.new({
      user_id: id,
      amount: amount,
      period_start: start_date,
      period_end: end_date
    })
    charge.success = Stripe::Charge.create(
      amount: amount,
      currency: 'usd',
      customer: stripe_customer_token
    )["paid"] rescue false
    charge.save
    if charge.success
      FileRequest
        .where(["end_date < ? AND user_charge_id IS NULL", Date.today.at_beginning_of_month])
        .update_all(user_charge_id: charge.id)
    end
  end

  def unpaid_request_payable_period
    file_ids = self.uploaded_files.pluck(:id)
    start = FileRequest.select(:start_date).where([
      "uploaded_file_id IN (?) AND end_date < ? AND user_charge_id IS NULL",
      file_ids,
      Date.today.at_beginning_of_month
    ]).order("start_date ASC").first.start_date
    { start: start, end: (Date.today - 1.month).at_end_of_month }
  end

  def unpaid_requests payable
    file_ids = self.uploaded_files.pluck(:id)
    if payable
      FileRequest.where([
        "uploaded_file_id IN (?) AND end_date < ? AND user_charge_id IS NULL",
        file_ids,
        Date.today.at_beginning_of_month
      ])
    else
      FileRequest.where([
        "uploaded_file_id IN (?) AND user_charge_id IS NULL",
        file_ids
      ])
    end
  end

  def current_cost only_payable = false
    c = CostCalculator.new
    c.bytes = current_byte_usage only_payable
    c.s3_cost
  end

  def current_charge only_payable = false
    c = CostCalculator.new
    c.bytes = current_byte_usage only_payable
    c.charge
  end

  def current_final_charge only_payable = false
    c = CostCalculator.new
    c.bytes = current_byte_usage only_payable
    charge = c.final_charge
    charge - (charge * discount_percent)
  end

  def current_byte_usage only_payable = false
    requests = unpaid_requests only_payable
    byte_usage = 0
    requests.each do |r|
      # I'm adding 1 to the requests count to account for the original upload
      requests = r.requests + 1
      size = r.uploaded_file.size || 0
      byte_usage += requests * size
    end
    byte_usage
  end

end
