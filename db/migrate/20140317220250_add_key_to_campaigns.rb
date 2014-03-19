class PrerollOutput < ActiveRecord::Base
  self.table_name = "preroller_outputs"
  has_many :campaigns, class_name: "PrerollCampaign", foreign_key: "output_id"
end

class AddKeyToCampaigns < ActiveRecord::Migration
  def change
    add_column :preroller_campaigns, :key, :string
    add_index :preroller_campaigns, :key

    PrerollOutput.all.each do |o|
      o.campaigns.each { |c| c.update_column(:key, o.key) }
    end
  end
end
