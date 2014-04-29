require 'spec_helper'

describe Api::Public::V1::VisualCampaignsController do
  render_views

  describe 'show' do
    let(:campaign) {
      create :visual_campaign,
        :active,
        :output_key   => "pushdown",
        :domains      => "scpr.org,www.scpr.org",
        :markup       => "<div>WAT</div>"
    }

    before do
      request.headers['Origin'] = "http://scpr.org"
    end

    context 'with valid campaign' do
      before do
        get :show, key: campaign.output_key, format: :json
      end

      it "returns the requested campaign" do
        assigns(:visual_campaign).should eq campaign
      end

      it "returns the object" do
        json = JSON.parse(response.body)
        json["visual_campaign"]["markup"].should eq campaign.markup.as_json
        json["visual_campaign"]["key"].should eq campaign.output_key.as_json
        json["visual_campaign"]["domains"].should eq campaign.domains.as_json
        json["visual_campaign"]["title"].should eq campaign.title.as_json
        json["visual_campaign"]["starts_at"].should eq campaign.starts_at.xmlschema
        json["visual_campaign"]["ends_at"].should eq campaign.ends_at.xmlschema
        json["visual_campaign"]["cookie_key"].should eq campaign.cookie_key.as_json
        json["visual_campaign"]["cookie_ttl_hours"].should eq campaign.cookie_ttl_hours.as_json
      end

      it "selects a random campaign if there are multiple with the same key" do
        create :visual_campaign, :active, output_key: "pushdown"
        get :show, key: campaign.output_key, format: :json
        assigns(:visual_campaign).should be_present
      end
    end

    context 'with missing Origin' do
      before do
        request.headers['Origin'] = nil
      end

      it "renders a bad request and doesn't set @visual_campaign" do
        get :show, key: "nopenope", format: :json
        response.should be_bad_request
        assigns(:visual_campaign).should be_nil
      end
    end

    context "with invalid key" do
      it "renders 404 not found" do
        get :show, key: "nopenopeopne", format: :json
        response.should be_not_found
        assigns(:visual_campaign).should be_nil
      end

      it "only pulls active campaigns" do
        create :visual_campaign, :inactive, output_key: "hello"
        get :show, key: "hello", format: :json

        response.should be_not_found
      end
    end

    context "with unauthorized domain" do
      before do
        request.headers['Origin'] = "http://another-website.com"
      end

      it 'renders unauthorized' do
        get :show, key: campaign.output_key, format: :json
        response.status.should eq 401
      end
    end

    context "with campaign with no domain restriction" do
      let(:campaign) { create :visual_campaign, :active, domains: "" }

      before do
        request.headers['Origin'] = "http://another-website.com"
      end

      it 'renders okay' do
        get :show, key: campaign.output_key, format: :json
        response.should be_ok
      end
    end
  end
end
