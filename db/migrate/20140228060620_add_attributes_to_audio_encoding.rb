class AddAttributesToAudioEncoding < ActiveRecord::Migration
  def change
    add_column :preroller_audio_encodings, :type, :string
    add_column :preroller_audio_encodings, :sample_rate, :integer
    add_column :preroller_audio_encodings, :bitrate, :integer
    add_column :preroller_audio_encodings, :profile, :integer
    add_column :preroller_audio_encodings, :channels, :integer
  end
end
