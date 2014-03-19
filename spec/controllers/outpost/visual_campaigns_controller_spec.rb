require 'spec_helper'

describe Outpost::VisualCampaignsController do
  before do
    controller.stub(:current_user) { create :user }
  end

  let(:campaign) { create :visual_campaign, title: "Campaign!" }

  let(:valid_params) do
    build(:visual_campaign).attributes
      .slice(*%w(title output_key markup starts_at ends_at domains))
  end

  let(:invalid_params) do
    build(:visual_campaign, :invalid).attributes
      .slice(*%w(title output_key markup starts_at ends_at domains))
  end


  describe 'index' do
    it "assigns @records" do
      campaign1 = create :visual_campaign, :active
      campaign2 = create :visual_campaign, :active
      campaign3 = create :visual_campaign, :inactive

      get :index

      assigns(:records).sort.should eq [campaign1, campaign2, campaign3].sort
    end
  end

  describe 'show' do
    it "assigns @record" do
      get :show, id: campaign.id
      assigns(:record).should eq campaign
    end
  end

  describe 'edit' do
    it "assigns @record" do
      get :show, id: campaign.id
      assigns(:record).should eq campaign
    end
  end

  describe 'new' do
    it "assigns @record to a new object" do
      get :new
      assigns(:record).should be_new_record
    end
  end

  describe 'create' do
    context 'valid record' do
      before do
        post :create,
          :visual_campaign => valid_params
      end

      it 'creates the record' do
        assigns(:record).should be_persisted
      end

      it "redirects to edit page" do
        response.should redirect_to outpost_visual_campaigns_path
      end
    end

    context 'invalid record' do
      before do
        post :create, visual_campaign: invalid_params
      end

      it "doesn't save the record" do
        VisualCampaign.count.should eq 0
      end

      it 'renders new template' do
        response.should render_template 'new'
      end
    end
  end

  describe 'update' do
    it "assigns @record" do
      put :update, id: campaign.id, visual_campaign: { title: "Updated" }
      assigns(:record).should eq campaign
    end

    context 'valid record' do
      it "updates the object" do
        put :update, id: campaign.id, visual_campaign: { title: "Testing 123" }
        VisualCampaign.find(campaign.id).title.should eq "Testing 123"
      end

      it 'redirects to edit' do
        put :update, id: campaign.id, visual_campaign: { title: "Updated" }
        response.should redirect_to outpost_visual_campaigns_path
      end
    end

    context 'invalid record' do
      it "doesn't update the object" do
        put :update, id: campaign.id, visual_campaign: { title: "" }
        VisualCampaign.find(campaign.id).title.should eq "Campaign!"
      end

      it 'renders edit' do
        put :update, id: campaign.id, visual_campaign: { title: "" }
        response.should render_template 'edit'
      end
    end
  end

  describe 'destroy' do
    it "assigns @record" do
      delete :destroy, id: campaign.id
      assigns(:record).should eq campaign
    end

    it 'destroys the object' do
      campaign # Load the object

      VisualCampaign.count.should eq 1
      delete :destroy, id: campaign.id
      VisualCampaign.count.should eq 0
    end
  end
end
