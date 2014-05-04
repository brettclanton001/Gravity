require 'spec_helper'

describe "Account/Stripe functionality" do
  before do
    @user = create :confirmed_user
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

end
