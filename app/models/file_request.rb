class FileRequest < ActiveRecord::Base
  belongs_to :uploaded_file
  belongs_to :user_charge
end
