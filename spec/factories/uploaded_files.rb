# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :uploaded_file, :class => 'UploadedFile' do
    user_id 1
    #token "MyString"
    #upload "MyString"
    #file_size 1
  end
end
