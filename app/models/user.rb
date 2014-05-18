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

  def new_charge amount
    Stripe::Charge.create(
      amount: amount,
      currency: 'usd',
      customer: stripe_customer_token
    )
  end

  def current_cost
    c = CostCalculator.new
    c.bytes = current_byte_usage
    c.s3_cost
  end

  def current_charge
    c = CostCalculator.new
    c.bytes = current_byte_usage
    c.charge
  end

  def current_final_charge
    c = CostCalculator.new
    c.bytes = current_byte_usage
    c.final_charge
  end

  def current_byte_usage
    file_ids = self.uploaded_files.pluck(:id)
    unpaid_requests = FileRequest.where( uploaded_file_id: file_ids, user_charge_id: nil )
    byte_usage = 0
    unpaid_requests.each do |r|
      # I'm adding 1 to the requests count to account for the original upload
      requests = r.requests + 1
      size = r.uploaded_file.size || 0
      byte_usage += requests * size
    end
    byte_usage
  end

end
