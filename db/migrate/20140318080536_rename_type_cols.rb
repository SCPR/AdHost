class RenameTypeCols < ActiveRecord::Migration
  def up
    AudioEncoding.where(type: "Preroller::AACAudioEncoding").update_all(type: "AACAudioEncoding")
    AudioEncoding.where(type: "Preroller::MP3AudioEncoding").update_all(type: "MP3AudioEncoding")
  end

  def down
    AudioEncoding.where(type: "AACAudioEncoding").update_all(type: "Preroller::AACAudioEncoding")
    AudioEncoding.where(type: "MP3AudioEncoding").update_all(type: "Preroller::MP3AudioEncoding")
  end
end
