class MP3AudioEncoding < AudioEncoding
  CODEC       = 'libmp3lame'
  EXTENSION   = "mp3"


  def profile
    nil # AAC only
  end

  def bitrate
    key_parts[2].to_i
  end

  def channels
    key_parts[3] == 'm' ? 1 : 2
  end

  def extension
    EXTENSION
  end


  private

  def transcode(master, temp)
    master.transcode(temp.path, {
      :custom => "-reservoir 0 " \
                 "-metadata title=\"#{self.campaign.title.gsub('"','\"')}\"",
      :audio_codec       => CODEC,
      :audio_bitrate     => self.bitrate,
      :audio_sample_rate => self.sample_rate,
      :audio_channels    => self.channels
    })
  end
end
