class RemoveOldColumns < ActiveRecord::Migration
  def change
    drop_table :preroller_outputs
    remove_column :preroller_campaigns, :metatitle
    remove_column :preroller_campaigns, :active
    remove_column :preroller_campaigns, :output_id
    remove_column :preroller_campaigns, :ua_filter

    remove_column :preroller_audio_encodings, :extension
    remove_column :preroller_audio_encodings, :size
    remove_column :preroller_audio_encodings, :duration
    remove_column :preroller_audio_encodings, :sample_rate
    remove_column :preroller_audio_encodings, :bitrate
    remove_column :preroller_audio_encodings, :profile
    remove_column :preroller_audio_encodings, :channels
    remove_column :preroller_audio_encodings, :is_master

    remove_column :visual_campaigns, :is_active
  end
end
