class SeedAudioAttributeColumns < ActiveRecord::Migration
  def change
    #seed new column with master information from old column
    Preroller::AudioEncoding.where(is_master: false).each do |a|
      stream_key = a.stream_key
      codec, encoding_options = stream_key.split '-', 2
      if codec == 'mp3'
        sample_rate, bitrate, mode = encoding_options.split '-', 3
        channels = mode == 's' ? 2 : 1
        a.sample_rate = sample_rate
        a.bitrate = bitrate
        a.channels = channels
        a.type = 'Preroller::MP3AudioEncoding'
        a.save
      elsif codec == 'aac'
        sample_rate, profile, channels = encoding_options.split '-', 3
        a.sample_rate = sample_rate
        a.profile = profile
        a.channels = channels
        a.type = 'Preroller::AACAudioEncoding'
        a.save
      end
    end
  end
end

