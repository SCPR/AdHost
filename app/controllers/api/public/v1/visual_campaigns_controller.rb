module Api::Public::V1
  class VisualCampaignsController < BaseController
    before_filter :sanitize_origin, only: [:index, :show]
    before_filter :allow_origin, only: [:index]
    before_filter :set_conditions, only: [:index]
    before_filter :sanitize_keys, only: [:index]

    before_filter :sanitize_key, only: [:show]

    def index
      @visual_campaigns = VisualCampaign.active.where(@conditions)

      # For index, we won't return any errors - just filter out the
      # unallowed campaigns
      @visual_campaigns = @visual_campaigns.select do |campaign|
        campaign.allowed_domains.blank? ||
        campaign.allowed_domains.find { |d| d == @origin.host }
      end

      respond_with @visual_campaigns
    end


    def show
      @visual_campaign = VisualCampaign.active.where(output_key: @key).sample

      if !@visual_campaign
        render_not_found and return false
      end

      # TODO This should be able to select a campaign which has a more
      # specific domain restriction.
      if @visual_campaign.allowed_domains.present?
        if !@visual_campaign.allowed_domains.find { |d| d == @origin.host }
          # FIXME Should we really be sending back a 401 here?
          # It would probably be better just to return an empty object
          # or something. Currently the allowed_domains is trying to
          # do too many things.
          render_unauthorized and return false
        end
      end

      allow_origin
      respond_with @visual_campaign
    end


    private

    def sanitize_key
      @key = params[:key].to_s
    end

    def sanitize_keys
      if params[:keys]
        keys = params[:keys].to_s.split(',').uniq
        @conditions[:output_key] = keys
      end
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
