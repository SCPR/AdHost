class MigrateMasterAudioEncodings < ActiveRecord::Migration
  def up
    AudioEncoding.where(stream_key: 'master').each do |e|
      fn = "#{e.campaign_id}-#{e.fingerprint}.#{e.attributes['extension']}"
      e.campaign.update_column(:master_file, fn)
    end
  end

  def down
  end
end
