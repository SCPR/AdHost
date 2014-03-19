class Outpost::HomeController < Outpost::BaseController
  def index
    breadcrumb "Dashboard", outpost_root_path

    @active_preroll_campaigns = PrerollCampaign.active
    @active_visual_campaigns = VisualCampaign.active
  end

  def not_found
    render_error(404, ActionController::RoutingError.new("Not Found"))
  end
end
