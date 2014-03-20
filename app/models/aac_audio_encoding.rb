class AACAudioEncoding < AudioEncoding
  CODEC       = 'libfdk_aac'
  PROFILE     = 'mpeg2_aac_low'
  EXTENSION   = "m4a"


  def bitrate
    nil # MP3 only
  end

  def profile
    key_parts[2].to_i
  end

  def channels
    key_parts[3].to_i
  end

  def extension
    EXTENSION
  end


  private

  def transcode(master, temp)
    master.transcode(temp.path, {
      :custom => "-metadata title=\"#{self.campaign.title.gsub('"','\"')}\"",
      :audio_codec       => CODEC,
      :audio_profile     => PROFILE,
      :audio_sample_rate => self.sample_rate,
      :audio_channels    => self.channels
    })
  end
end
