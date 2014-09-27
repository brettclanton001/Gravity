class AddBillableToFileRequests < ActiveRecord::Migration
  def change
    add_column :file_requests, :billable, :boolean
  end
end
