# encoding: utf-8

class FileUploader < CarrierWave::Uploader::Base

  include CarrierWave::RMagick

  storage :fog

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

end
