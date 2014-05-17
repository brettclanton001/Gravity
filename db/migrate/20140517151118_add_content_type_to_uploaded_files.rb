class AddContentTypeToUploadedFiles < ActiveRecord::Migration
  def change
    add_column :uploaded_files, :content_type, :string
  end
end
