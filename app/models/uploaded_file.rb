class UploadedFile < ActiveRecord::Base

  IMAGE_EXTENSIONS = ['jpg', 'jpeg', 'gif', 'png']

  belongs_to :users

  mount_uploader :upload, FileUploader

  validates_uniqueness_of :token

  def self.find_with_token token
    where(token: token).first
  end

  def cached_file
    tmp_file = nil
    begin
      tmp_file = open(Rails.cache.read([:file_path, id]))
    rescue
      tmp_file = uploaded_file
      Rails.cache.write([:file_path, id], tmp_file.to_path)
    end
    tmp_file
  end

  def uploaded_file
    open(upload_url, "rb")
  end

  def type
    filename = File.basename(upload.path)
    if filename.split('.').length > 1
      extension = filename.split('.').last.downcase
      if IMAGE_EXTENSIONS.include?(extension)
        "image/#{extension}"
      elsif extension == 'pdf'
        "file/pdf"
      else
        "file/#{extension}"
      end
    else
      ''
    end
  end
end
