class PopulateStreamKey < ActiveRecord::Migration
  def up
    remove_index :preroller_audio_encodings,
      :name => "index_preroller_audio_encodings_on_campaign_id_and_stream_key"

    AACAudioEncoding.where(is_master: false).each do |e|
      c = 'aac'
      s = e.attributes["sample_rate"]
      p = e.attributes["profile"]
      n = e.attributes["channels"]

      e.update_column(:stream_key, "#{c}-#{s}-#{p}-#{n}")
    end

    MP3AudioEncoding.where(is_master: false).each do |e|
      c = 'mp3'
      s = e.attributes["sample_rate"]
      b = e.attributes["bitrate"]
      n = e.attributes["channels"]
      n = n == 2 ? 's' : 'm'

      e.update_column(:stream_key, "#{c}-#{s}-#{b}-#{n}")
    end

    AudioEncoding.where(is_master: true).each do |e|
      e.update_column(:stream_key, 'master')
    end
  end

  def down
  end
end
