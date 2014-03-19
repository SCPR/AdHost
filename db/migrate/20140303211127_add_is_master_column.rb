class AddIsMasterColumn < ActiveRecord::Migration
  def change
    add_column :preroller_audio_encodings, :is_master, :boolean, default: false
  end
end
