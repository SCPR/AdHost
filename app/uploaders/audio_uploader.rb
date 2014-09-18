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
    Rails.application.config.audio_dir
  end


  def filename
    if original_filename.present?
      var = "@#{mounted_as}_secure_token"

      fingerprint = model.instance_variable_get(var) ||
        model.instance_variable_set(var, SecureRandom.hex(16))

      "master-#{fingerprint}.#{file.extension}"
    end
  end


  def extension_white_list
    %w{ mp3 wav }
  end
end
