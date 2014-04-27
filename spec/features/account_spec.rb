require 'spec_helper'

describe "Account/Stripe functionality" do
  before do
    @user = create :confirmed_user
    visit root_path
    click_link 'login'
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
      page.should have_text 'Current Payment Methods'
    end

  end
end
