class CreateVisualCampaigns < ActiveRecord::Migration
  def up
    create_table :visual_campaigns do |t|
      t.string :title
      t.string :key
      t.text :markup
      t.string :domains
      t.boolean :is_active
      t.timestamps
    end
  end

  def down
    drop_table :visual_campaigns
  end
end
