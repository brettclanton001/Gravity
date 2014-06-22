FactoryGirl.define do
  factory :user do
    email "testuser1@example.com"
    password 'password123'
    password_confirmation 'password123'
    active true
    active_payments true

    factory :confirmed_user do
      confirmed_at Time.now - 10.minutes
    end

    factory :confirmed_user_pre_payment do
      confirmed_at Time.now - 10.minutes
      active_payments false
    end
  end
end
