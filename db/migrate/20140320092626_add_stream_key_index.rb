class AddStreamKeyIndex < ActiveRecord::Migration
  def change
    add_index :preroller_audio_encodings, :stream_key
    add_index :preroller_audio_encodings, :type
  end
end
