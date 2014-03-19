class AddMasterFileToCampaigns < ActiveRecord::Migration
  def change
    add_column :preroller_campaigns, :master_file, :string
  end
end
