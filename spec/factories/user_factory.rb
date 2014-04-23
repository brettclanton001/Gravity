FactoryGirl.define do
  factory :user do
    email "testuser1@example.com"
    password 'password123'
    password_confirmation 'password123'
  end

  # This will use the User class (Admin would have been guessed)
  #factory :admin, class: User do
    #first_name "Admin"
    #last_name  "User"
    #admin      true
  #end
end
