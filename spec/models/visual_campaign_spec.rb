require 'spec_helper'

describe VisualCampaign do
  describe '::active' do
    it "selects currently active campaigns" do
      active = create :visual_campaign,
        :starts_at => 1.day.ago,
        :ends_at   => 1.day.from_now

      inactive = create :visual_campaign,
        :starts_at => 1.day.from_now,
        :ends_at   => 2.days.from_now

      VisualCampaign.active.to_a.should eq [active]
    end
  end

  describe '#allowed_domains' do
    it "is an array of the allowed domains" do
      campaign = build :visual_campaign, domains: "scpr.org,scprdev.org"
      campaign.allowed_domains.should eq ["scpr.org", "scprdev.org"]
    end
  end
end
