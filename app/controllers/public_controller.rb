class PublicController < ApplicationController
  layout false

  # Handle a preroll request, delivering either a preroll file encoded in
  # the format asked for by the stream or an empty response if there is no
  # preroll
  def preroll
    campaigns = PrerollCampaign.active.where(output_key: params[:key])

    # The consistent_preroll option  gives us the opportunity to
    # ensure that the same preroll will always be returned, so
    # that we can know (more or less) what the response content-length
    # will be.
    # If a specific context was given, try to find a campaign
    # which matches that context. If no campaign matches, then
    # we'll just select a random active campaign.
    if params[:consistentPreroll].present?
      @campaign = campaigns.first
    elsif params[:context].present?
      @campaign = campaigns.select { |c|
        c.path_filter.present? && params[:context].match(c.path_filter)
      }.sample
    end

    @campaign ||= campaigns.select { |c| c.path_filter.blank? }.sample

    if @campaign
      if file = @campaign.file_for_stream_key(params[:stream_key])
        # Got it... send a file
        send_file file, :disposition => 'inline' and return
      end
    end

    render :text => "", :status => :ok and return
  end


  def listeners
    uri = URI("#{Rails.application.config.streamadmin.cube_server}" \
      "/1.0/metric?expression=sum(stream_minutes(duration))/60&step=6e4&limit=1")

    json = Net::HTTP.get(uri)
    @response = JSON.parse(json)
  end
end
