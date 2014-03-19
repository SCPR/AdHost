json.visual_campaign do
  json.partial! 'api/public/v1/visual_campaigns/visual_campaign',
    :visual_campaign => @visual_campaign
end
