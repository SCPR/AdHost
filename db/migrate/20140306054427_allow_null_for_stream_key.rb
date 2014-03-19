class AllowNullForStreamKey < ActiveRecord::Migration
  def up
    change_column :preroller_audio_encodings, :stream_key, :string, :null => true
  end

  def down
    change_column :preroller_audio_encodings, :stream_key, :string, :null => false
  end
end
