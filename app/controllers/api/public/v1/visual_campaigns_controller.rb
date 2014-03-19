module Api::Public::V1
  class VisualCampaignsController < BaseController
    before_filter :sanitize_origin, only: [:show]
    before_filter :sanitize_key, only: [:show]

    def show
      @visual_campaign = VisualCampaign.active.where(output_key: @key).sample

      if !@visual_campaign
        render_not_found and return false
      end

      if !@visual_campaign.allowed_domains.find { |d| d == @origin.host }
        render_unauthorized and return false
      else
        allow_origin
      end

      respond_with @visual_campaign
    end


    private

    def sanitize_key
      @key = params[:key].to_s
    end

    def sanitize_origin
      if request.headers['Origin'].blank?
        render_bad_request(message: "Origin header must be set.")
        return false
      end

      @origin = URI(request.headers['Origin'].to_s)
    end
  end
end