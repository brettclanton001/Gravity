FactoryGirl.define do
  factory :user do
    email "testuser1@example.com"
    encrypted_password '$2a$04$gLuMfkkzF0f6kTSsuvbCBOukcookaYy0kE9vp88jHownV36yLLm9S'
  end

  # This will use the User class (Admin would have been guessed)
  #factory :admin, class: User do
    #first_name "Admin"
    #last_name  "User"
    #admin      true
  #end
end
