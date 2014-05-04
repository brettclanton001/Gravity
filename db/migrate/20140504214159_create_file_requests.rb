class CreateFileRequests < ActiveRecord::Migration
  def change
    create_table :file_requests do |t|
      t.integer :uploaded_file_id
      t.integer :requests, :default => 0
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
    add_index :file_requests, :uploaded_file_id, name: 'file_request_by_uploaded_file_id'
  end
end
