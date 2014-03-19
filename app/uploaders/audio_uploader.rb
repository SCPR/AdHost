require 'securerandom'

class AudioUploader < CarrierWave::Uploader::Base
  storage :file
  permissions 0777

  def move_to_cache
    Rails.env != 'test'
  end

  def move_to_store
    Rails.env != 'test'
  end


  def store_dir
    Rails.application.config.preroller.audio_dir
  end


  def filename
    return if !file
    fingerprint = SecureRandom.hex(4)
    @random_filename ||= "#{model.id}-#{fingerprint}-#{file.extension}"
  end


  def extension_white_list
    %w{ mp3 wav }
  end
end
