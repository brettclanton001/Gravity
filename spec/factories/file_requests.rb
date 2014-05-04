# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :file_request do
    uploaded_file_id 1
    requests 1
    start_date "2014-05-04"
    end_date "2014-05-04"
  end
end
