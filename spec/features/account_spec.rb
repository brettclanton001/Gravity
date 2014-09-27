require 'spec_helper'

describe "Account/Stripe functionality" do
  before do
    @user = create :confirmed_user_pre_payment
    visit root_path
    within '.header' do
      click_link 'Login'
    end
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

    it "should display payment history header" do
      page.should have_text 'Payment History'
    end
  end

  describe "Uploads Page" do

    context "discount" do
      before do
        User.any_instance.stub(:is_in_trial_period?).and_return(false)
      end

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

    context "trial period" do
      it "should allow usage with values of zero" do
        User.any_instance.stub(:historical_byte_usage).and_return(0)
        User.any_instance.stub(:historical_storage_usage).and_return(0)
        visit uploads_path
        current_url.include?('/uploads').should be true
      end

      it "should allow usage with typical values" do
        User.any_instance.stub(:historical_byte_usage).and_return(User::TRIAL_TRANSFER / 2)
        User.any_instance.stub(:historical_storage_usage).and_return(User::TRIAL_STORAGE / 2)
        visit uploads_path
        current_url.include?('/uploads').should be true
      end

      it "should not allow usage with too much transfer" do
        User.any_instance.stub(:historical_byte_usage).and_return(User::TRIAL_TRANSFER)
        User.any_instance.stub(:historical_storage_usage).and_return(User::TRIAL_STORAGE / 2)
        visit uploads_path
        current_url.include?('/account/payment_methods').should be true
      end

      it "should not allow usage with much too much transfer" do
        User.any_instance.stub(:historical_byte_usage).and_return(User::TRIAL_TRANSFER * 2)
        User.any_instance.stub(:historical_storage_usage).and_return(User::TRIAL_STORAGE / 2)
        visit uploads_path
        current_url.include?('/account/payment_methods').should be true
      end

      it "should not allow usage with too much storage" do
        User.any_instance.stub(:historical_byte_usage).and_return(User::TRIAL_TRANSFER / 2)
        User.any_instance.stub(:historical_storage_usage).and_return(User::TRIAL_STORAGE)
        visit uploads_path
        current_url.include?('/account/payment_methods').should be true
      end

      it "should not allow usage with much too much storage" do
        User.any_instance.stub(:historical_byte_usage).and_return(User::TRIAL_TRANSFER / 2)
        User.any_instance.stub(:historical_storage_usage).and_return(User::TRIAL_STORAGE * 2)
        visit uploads_path
        current_url.include?('/account/payment_methods').should be true
      end

      it "should not allow usage with too much of both" do
        User.any_instance.stub(:historical_byte_usage).and_return(User::TRIAL_TRANSFER)
        User.any_instance.stub(:historical_storage_usage).and_return(User::TRIAL_STORAGE)
        visit uploads_path
        current_url.include?('/account/payment_methods').should be true
      end

      it "should not allow usage with much too much of both" do
        User.any_instance.stub(:historical_byte_usage).and_return(User::TRIAL_TRANSFER * 2)
        User.any_instance.stub(:historical_storage_usage).and_return(User::TRIAL_STORAGE * 2)
        visit uploads_path
        current_url.include?('/account/payment_methods').should be true
      end
    end
  end

end
