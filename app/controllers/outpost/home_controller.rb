class Outpost::HomeController < Outpost::BaseController
  def dashboard
    breadcrumb "Dashboard", outpost.root_path

    @active_preroll_campaigns = PrerollCampaign.active
    @active_visual_campaigns = VisualCampaign.active
  end
end
