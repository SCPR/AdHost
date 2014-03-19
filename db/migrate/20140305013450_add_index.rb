class AddIndex < ActiveRecord::Migration
  def up
    add_index :preroller_audio_encodings, :campaign_id
    add_index :preroller_audio_encodings, [:sample_rate, :bitrate, :channels], name: "audio_metadata"
    add_index :preroller_audio_encodings, :is_master

    add_index :preroller_outputs, :key

    add_index :preroller_campaigns, :path_filter
    add_index :preroller_campaigns, [:active, :start_at, :end_at], name: "active_status"
    add_index :preroller_campaigns, :created_at
  end

  def down
    remove_index :preroller_audio_encodings, :campaign_id
    remove_index :preroller_audio_encodings, name: "audio_metadata"
    remove_index :preroller_audio_encodings, :is_master

    remove_index :preroller_outputs, :key

    remove_index :preroller_campaigns, :path_filter
    remove_index :preroller_campaigns, name: "active_status"
    remove_index :preroller_campaigns, :created_at
  end
end
