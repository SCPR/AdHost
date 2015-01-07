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
      if encoding = @campaign.encoding_for_stream_key(params[:stream_key])
        if obj = encoding.s3_object
          # Got it... send a file
          send_data obj.read(), :type => "audio/mpeg", :disposition => 'inline' and return
        end
      end
    end

    render :text => "", :status => :ok and return
  end


  def listeners
    stats = StreamStats.get()

    if !stats
      render :xml => { code: 503, error: "Temporarily unavailable" },
             :status => :service_unavailable

      return
    end

    @time       = stats.ts
    @listeners  = stats.listeners
  end
end
