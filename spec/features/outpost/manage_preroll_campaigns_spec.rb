require 'spec_helper'

describe "Preroll Campaigns" do
  describe "index" do
    before do
      login
    end

    it "lists all preroll campaigns" do
      campaign1 = create :preroll_campaign, title: "xxCampaign1--"
      campaign2 = create :preroll_campaign, title: "xxCampaign2--"

      visit outpost_preroll_campaigns_path
      page.should have_content "xxCampaign1--"
      page.should have_content "xxCampaign2--"
    end
  end

  describe "show" do
    before do
      login

      @preroll_campaign = create :preroll_campaign,
        :title        => "Cool Campaign",
        :output_key   => "coolio"
    end

    it "redirects to edit" do
      visit outpost_preroll_campaign_path(@preroll_campaign)
      current_path.should eq edit_outpost_preroll_campaign_path(@preroll_campaign)
    end
  end

  describe "creating" do
    before do
      login
      visit outpost_preroll_campaigns_path
      click_link "Add Preroll Campaign"
    end

    context "valid record" do
      it "shows a success message and redirects to the edit page" do
        fill_in "preroll_campaign_title", with: "Cool Campaign"
        click_button "Save"

        current_path.should eq edit_outpost_preroll_campaign_path(PrerollCampaign.last)
        page.should have_content "Saved Preroll Campaign"
      end
    end

    context "invalid record" do
      it "renders the new template and shows error messages" do
        fill_in "preroll_campaign_title", with: ""
        click_button "Save"

        current_path.should eq outpost_preroll_campaigns_path # "create" action
        page.should have_content "can't be blank"
      end
    end
  end

  describe "updating" do
    before do
      login
      @preroll_campaign = create :preroll_campaign
      visit outpost_preroll_campaigns_path
      click_link "Edit"
    end

    context "valid record" do
      it "shows a success message and redirects to the edit page" do
        fill_in "preroll_campaign_title", with: "Updated Campaign Title"
        click_button "Save"

        current_path.should eq edit_outpost_preroll_campaign_path(PrerollCampaign.last)
        page.should have_content "Saved Preroll Campaign"
        page.should have_content "Updated Campaign Title"
      end
    end

    context "invalid record" do
      it "renders the new template and shows error messages" do
        fill_in "preroll_campaign_title", with: ""
        fill_in "preroll_campaign_output_key", with: ""
        click_button "Save"

        # "update" action
        current_path.should eq outpost_preroll_campaign_path(@preroll_campaign)
        page.should have_content "can't be blank"
      end
    end
  end

  describe "destroying" do
    before do
      login
      @preroll_campaign = create :preroll_campaign
      visit outpost_preroll_campaigns_path
      click_link "Edit"
    end

    it "deletes the record" do
      click_link "Delete this Preroll Campaign"

      current_path.should eq outpost_preroll_campaigns_path
      page.should have_content "Deleted Preroll Campaign"
    end
  end
end
