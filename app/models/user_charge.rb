class UserCharge < ActiveRecord::Base
  belongs_to :user
  has_many :file_requests
end
