class FixInactivePreroll < ActiveRecord::Migration
  def up
    PrerollCampaign.active.where(active: false).each do |campaign|
      campaign.update_column(:ends_at, campaign.starts_at)
    end
  end

  def down
  end
end
