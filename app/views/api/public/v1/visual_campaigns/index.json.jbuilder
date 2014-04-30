json.visual_campaigns do
  @visual_campaigns.each do |visual_campaign|
    json.set! visual_campaign.output_key do
      json.partial! 'api/public/v1/visual_campaigns/visual_campaign',
        :visual_campaign => visual_campaign
    end
  end
end
