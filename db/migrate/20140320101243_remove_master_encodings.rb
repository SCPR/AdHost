class RemoveMasterEncodings < ActiveRecord::Migration
  def change
    AudioEncoding.where(stream_key: "master").destroy_all
  end
end
