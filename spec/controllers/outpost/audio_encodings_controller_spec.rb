require 'spec_helper'

describe Outpost::AudioEncodingsController do
  before do
    controller.stub(:current_user) { create :user }
  end

  describe 'destroy' do
    before do
      @campaign = create :preroll_campaign
      @encoding = create :mp3_audio_encoding, campaign: @campaign
    end

    it "destroys the encoding" do
      AudioEncoding.count.should eq 1
      delete :destroy, preroll_campaign_id: @campaign.id, id: @encoding.id
      AudioEncoding.count.should eq 0
    end

    it "redirects to preroll edit page" do
      delete :destroy, preroll_campaign_id: @campaign.id, id: @encoding.id
      response.should redirect_to @campaign.admin_edit_path
    end
  end
end
