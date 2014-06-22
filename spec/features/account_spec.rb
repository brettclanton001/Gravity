require 'spec_helper'

describe "Account/Stripe functionality" do
  before do
    @user = create :confirmed_user_pre_payment
    visit root_path
    click_link 'Login'
    within("#new_user") do
      fill_in 'Email', :with => @user.email
      fill_in 'Password', :with => @user.password
      click_on 'Sign in'
    end
  end

  describe "Payment Methods" do
    before do
      visit '/account/payment_methods'
    end

    it "should display current payment methods" do
      page.should have_text 'Payment Methods'
    end
  end

  describe "Payment History" do
    before do
      visit '/account/payment_history'
    end

    it "should display payment history" do
      page.should have_text 'Payment History'
    end
  end

  describe "Uploads Page" do
    it "should redirect users to payment methods page when the user has no payment methods" do
      visit uploads_path
      current_url.include?('/account/payment_methods').should be true
    end
    it "should redirect users to payment methods page when the user has no payment methods and no discount" do
      @user.update_attribute(:discount_percent, 0)
      visit uploads_path
      current_url.include?('/account/payment_methods').should be true
    end
    it "should redirect users to payment methods page when the user has no payment methods and some discount" do
      @user.update_attribute(:discount_percent, 50)
      visit uploads_path
      current_url.include?('/account/payment_methods').should be true
    end
    it "should not redirect users to payment methods page when the user has no payment methods and 100% discount" do
      @user.update_attribute(:discount_percent, 100)
      visit uploads_path
      current_url.include?('/uploads').should be true
    end
    it "should keep users at the uploads page when the user has a payment method" do
      @user.update_attribute(:active_payments, true)
      visit uploads_path
      current_url.include?('/uploads').should be true
    end
  end

end
