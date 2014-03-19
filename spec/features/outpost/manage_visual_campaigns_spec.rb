require 'spec_helper'

describe "Visual Campaigns" do
  describe "index" do
    before do
      login
    end

    it "lists all visual campaigns" do
      campaign1 = create :visual_campaign, title: "xxCampaign1--"
      campaign2 = create :visual_campaign, title: "xxCampaign2--"

      visit outpost_visual_campaigns_path
      page.should have_content "xxCampaign1--"
      page.should have_content "xxCampaign2--"
    end
  end

  describe "show" do
    before do
      login

      @visual_campaign = create :visual_campaign,
        :title        => "Cool Campaign",
        :output_key   => "coolio",
        :markup       => "hello",
        :domains      => "wat.org"
    end

    it "redirects to edit" do
      visit outpost_visual_campaign_path(@visual_campaign)
      current_path.should eq edit_outpost_visual_campaign_path(@visual_campaign)
    end
  end

  describe "creating" do
    before do
      login
      visit outpost_visual_campaigns_path
      click_link "Add Visual Campaign"
    end

    context "valid record" do
      it "shows a success message and redirects to the edit page" do
        fill_in "visual_campaign_title", with: "Cool Campaign"
        fill_in "visual_campaign_output_key", with: "cool-campaign"
        fill_in "visual_campaign_markup", with: "<div>Hello</div>"
        click_button "Save"

        current_path.should eq edit_outpost_visual_campaign_path(VisualCampaign.last)
        page.should have_content "Saved Visual Campaign"
      end
    end

    context "invalid record" do
      it "renders the new template and shows error messages" do
        fill_in "visual_campaign_title", with: ""
        fill_in "visual_campaign_output_key", with: ""
        click_button "Save"

        current_path.should eq outpost_visual_campaigns_path # "create" action
        page.should have_content "can't be blank"
      end
    end
  end

  describe "updating" do
    before do
      login
      @visual_campaign = create :visual_campaign
      visit outpost_visual_campaigns_path
      click_link "Edit"
    end

    context "valid record" do
      it "shows a success message and redirects to the edit page" do
        fill_in "visual_campaign_title", with: "Updated Campaign Title"
        click_button "Save"

        current_path.should eq edit_outpost_visual_campaign_path(VisualCampaign.last)
        page.should have_content "Saved Visual Campaign"
        page.should have_content "Updated Campaign Title"
      end
    end

    context "invalid record" do
      it "renders the new template and shows error messages" do
        fill_in "visual_campaign_title", with: ""
        fill_in "visual_campaign_output_key", with: ""
        click_button "Save"

        # "update" action
        current_path.should eq outpost_visual_campaign_path(@visual_campaign)
        page.should have_content "can't be blank"
      end
    end
  end

  describe "destroying" do
    before do
      login
      @visual_campaign = create :visual_campaign
      visit outpost_visual_campaigns_path
      click_link "Edit"
    end

    it "deletes the record" do
      click_link "Delete this Visual Campaign"

      current_path.should eq outpost_visual_campaigns_path
      page.should have_content "Deleted Visual Campaign"
    end
  end
end
