class CreateUploadedFile < ActiveRecord::Migration
  def change
    create_table :uploaded_files do |t|
      t.integer :user_id
      t.string :token
      t.string :upload
      t.integer :file_size

      t.timestamps
    end
    add_index :uploaded_files, :token,   name: 'uploaded_file_by_token', unique: true
    add_index :uploaded_files, :user_id, name: 'uploaded_file_by_user_id'
  end
end
