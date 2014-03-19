class AACAudioEncoding < AudioEncoding
  CODEC   = 'libfdk_aac'
  PROFILE = 'mpeg2_aac_low'


  def bitrate
    nil # MP3 only
  end

  def profile
    key_parts[2].to_i
  end

  def channels
    key_parts[3].to_i
  end


  private

  def transcode_options
    @transcode_options ||= {
      :audio_codec   => CODEC,
      :audio_profile => PROFILE,
    }
  end
end
