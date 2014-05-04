class AddUserChargeIdToFileRequests < ActiveRecord::Migration
  def change
    add_column :file_requests, :user_charge_id, :integer
  end
end
