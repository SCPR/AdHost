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

    it "trims whitespace" do
      campaign = build :visual_campaign, domains: "scpr.org, scprdev.org"
      campaign.allowed_domains.should eq ["scpr.org", "scprdev.org"]
    end
  end


  describe '#active?' do
    it "is true if it's currently live" do
      campaign = build :visual_campaign, :active
      campaign.active?.should eq true
    end

    it "if false if it's not live" do
      campaign = build :visual_campaign, :inactive
      campaign.active?.should eq false
    end

    it "is false if no start or end time" do
      campaign = build :visual_campaign, starts_at: nil, ends_at: nil
      campaign.active?.should eq false
    end

    it "is true if only end time and we're before it" do
      campaign = build :visual_campaign, starts_at: nil, ends_at: 1.day.from_now
      campaign.active?.should eq true
    end

    it "is true if only start time and we're after it" do
      campaign = build :visual_campaign, starts_at: 1.day.ago, ends_at: nil
      campaign.active?.should eq true
    end

    it "is false if only start time and we're before it" do
      campaign = build :visual_campaign, starts_at: 1.day.from_now, ends_at: nil
      campaign.active?.should eq false
    end

    it "is false if only end time and we're after it" do
      campaign = build :visual_campaign, starts_at: nil, ends_at: 1.day.ago
      campaign.active?.should eq false
    end
  end
end
