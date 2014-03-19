class AddStartAndEndTimesToVisualCampaigns < ActiveRecord::Migration
  def change
    add_column :visual_campaigns, :starts_at, :datetime
    add_column :visual_campaigns, :ends_at, :datetime

    add_index :visual_campaigns, [:starts_at, :ends_at]
  end
end
