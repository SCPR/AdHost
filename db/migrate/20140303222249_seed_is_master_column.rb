class SeedIsMasterColumn < ActiveRecord::Migration
  def change
    #seed new column with master information from old column
    Preroller::AudioEncoding.where(stream_key: 'master').update_all(is_master: true)
  end
end
