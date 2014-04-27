FactoryGirl.define do
  factory :user do
    email "testuser1@example.com"
    password 'password123'
    password_confirmation 'password123'

    factory :confirmed_user do
      confirmed_at Time.now - 10.minutes
    end
  end
end
