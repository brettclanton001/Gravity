require 'spec_helper'

describe "User / Stripe details" do
  describe "Stripe Data" do
    before do
      @user = create :user
    end

    it "should get a user token for each new user" do
      @user.stripe_customer_token.should_not be_nil
    end

    it "should create a stripe record with the email address info" do
      @user.stripe_customer["email"].should eq @user.email
    end

    it "should update the stripe customer info if the user is updated" do
      @user.update_attribute :email, 'newotheremail@example.com'
      @user.stripe_customer["email"].should eq @user.email
    end

  end
end
