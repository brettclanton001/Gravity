# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user_charge do
    user_id 1
    success false
    amount 1
    period_start "2014-05-04"
    period_end "2014-05-04"
  end
end
