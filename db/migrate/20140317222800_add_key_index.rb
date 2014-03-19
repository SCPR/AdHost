class AddKeyIndex < ActiveRecord::Migration
  def change
    add_index :visual_campaigns, :key
  end
end
