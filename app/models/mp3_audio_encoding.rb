class MP3AudioEncoding < AudioEncoding
  CODEC = 'libmp3lame'


  def profile
    nil # AAC only
  end

  def bitrate
    key_parts[2].to_i
  end

  def channels
    key_parts[3] == 'm' ? 1 : 2
  end


  private

  def transcode_options
    @transcode_options ||= {
      :audio_codec   => CODEC,
      :audio_bitrate => self.bitrate,
    }
  end
end
