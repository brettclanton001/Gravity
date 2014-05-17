# encoding: utf-8

class FileUploader < CarrierWave::Uploader::Base

  include CarrierWave::RMagick
  include CarrierWave::MimeTypes

  storage :fog

  process :set_content_type

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end


  CarrierWave.configure do |config|
    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => ENV['AWS_ID'],
      :aws_secret_access_key  => ENV['AWS_SECRET'],
      :region                 => 'us-east-1'
    }
    config.fog_directory  = 'gravityappco'
    config.asset_host     = 'http://gravityappco.s3.amazonaws.com'
    config.fog_public     = true
    config.fog_attributes = {'Cache-Control' => 'max-age=315576000'}
  end

  version :thumb, :if => :image? do
    process :resize_to_fill => [200, 120]
  end

  protected

  def image?(new_file)
    new_file.content_type.start_with? 'image'
  end
end
