class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

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

end
