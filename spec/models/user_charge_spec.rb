require 'spec_helper'

describe UserCharge do
  before do
    # filler data
    u1 = FactoryGirl.create(:user, email: 'fakeotheremail@example.com')
    u2 = FactoryGirl.create(:user, email: 'fakeotheremail2@example.com')
    u3 = FactoryGirl.create(:user, email: 'fakeotheremail3@example.com', discount_percent: 100)
    u4 = FactoryGirl.create(:user, email: 'fakeotheremail4@example.com')
    u5 = FactoryGirl.create(:user, email: 'fakeotheremail5@example.com', active: false)
    u6 = FactoryGirl.create(:user, email: 'fakeotheremail6@example.com', active_payments: false)
    f1 = FactoryGirl.create(:uploaded_file, token: 'f1', user_id: u2.id, file_size: 1234534213)
    FactoryGirl.create( # not old enough to charge
      :file_request,
      uploaded_file_id: f1.id,
      requests: 54,
      start_date: Date.today.at_beginning_of_month,
      end_date: Date.today.at_end_of_month
    )
    f2 = FactoryGirl.create(:uploaded_file, token: 'f2', user_id: u2.id, file_size: 12345623)
    FactoryGirl.create( # not enough usage to justify charging
      :file_request,
      uploaded_file_id: f2.id,
      requests: 100,
      start_date: (Date.today - 1.month).at_beginning_of_month,
      end_date: (Date.today - 1.month).at_end_of_month
    )
    FactoryGirl.create( # not old enough to charge, the month isn't over yet
      :file_request,
      uploaded_file_id: f2.id,
      requests: 80,
      start_date: Date.today.at_beginning_of_month,
      end_date: Date.today.at_end_of_month
    )
    f3 = FactoryGirl.create(:uploaded_file, token: 'f3', user_id: u3.id, file_size: 12345623)
    FactoryGirl.create( # this user has a 100% discount
      :file_request,
      uploaded_file_id: f3.id,
      requests: 100000,
      start_date: (Date.today - 1.month).at_beginning_of_month,
      end_date: (Date.today - 1.month).at_end_of_month
    )
    FactoryGirl.create( # not old enough to charge, the month isn't over yet
      :file_request,
      uploaded_file_id: f3.id,
      requests: 80000,
      start_date: Date.today.at_beginning_of_month,
      end_date: Date.today.at_end_of_month
    )
    # important data
    @user = FactoryGirl.create(:user)
    @file = FactoryGirl.create(:uploaded_file, token: 'f4', user_id: @user.id, file_size: 12345623)
    FactoryGirl.create(
      :file_request,
      uploaded_file_id: @file.id,
      requests: 100000,
      start_date: (Date.today - 1.month).at_beginning_of_month,
      end_date: (Date.today - 1.month).at_end_of_month
    )
    FactoryGirl.create(
      :file_request,
      uploaded_file_id: @file.id,
      requests: 80000,
      start_date: Date.today.at_beginning_of_month,
      end_date: Date.today.at_end_of_month
    )
  end

  it "should identify the user that needs to be charged" do
    User.find_charge_worthy_users.count.should be 3
  end

  it "should not charge users with no active cards" do
    @user.user_charges.count.should be 0
    User.charge_users
    @user.user_charges.count.should be 1
    @user.user_charges.first.success.should_not be_true
    FileRequest.where(uploaded_file_id: @file.id).pluck(:user_charge_id).should eq [nil, nil]
  end

  it "should charge the identified users" do
    @user.stripe_customer.cards.create(card: {number:'4242424242424242', cvc: '123', exp_month: '12', exp_year: '20'})['id']
    @user.user_charges.count.should be 0
    User.charge_users
    @user.user_charges.count.should be 1
    @user.user_charges.first.success.should be_true
    FileRequest.where(uploaded_file_id: @file.id).pluck(:user_charge_id).should_not eq [nil, nil]
  end

end
