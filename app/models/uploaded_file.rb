class UploadedFile < ActiveRecord::Base

  IMAGE_EXTENSIONS = ['jpg', 'jpeg', 'gif', 'png']

  belongs_to :users
  has_many :file_requests

  mount_uploader :upload, FileUploader

  validates_uniqueness_of :token

  before_create :record_file_size
  before_create :record_content_type

  def thumbnail
    if type.start_with? 'image'
      upload_url(:thumb)
    else
      '/assets/file_icon.png'
    end
  end

  def record_content_type
    self.content_type = upload.content_type
  end

  def record_file_size
    self.file_size = upload.file.size
  end

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

  def short_url
    "http://#{SHORT_DOMAIN}/i/#{token}"
  end

  def type
    update_attribute(:content_type, upload.content_type) unless content_type
    content_type
  end

  def log_file_request
    log = request_log
    log.update_attribute(:requests, log.requests + 1)
    log.requests
  end

  def request_log
    today = Date.today
    current_log = FileRequest.where([
      " uploaded_file_id = ? AND start_date <= ? AND end_date >= ? ",
      self.id,
      today,
      today
    ]).first
    if current_log.nil?
      current_log = FileRequest.create(
        uploaded_file_id: self.id,
        start_date: today.at_beginning_of_month,
        end_date: today.at_end_of_month
      )
    end
    current_log
  end
end
