class RenameCampaignScheduleCols < ActiveRecord::Migration
  def change
    rename_column :preroller_campaigns, :start_at, :starts_at
    rename_column :preroller_campaigns, :end_at, :ends_at
  end
end
