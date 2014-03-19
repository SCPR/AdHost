json.cache! [Api::Public::V1::VERSION, "v1", visual_campaign] do
  json.key         visual_campaign.output_key
  json.title       visual_campaign.title
  json.starts_at   visual_campaign.starts_at
  json.ends_at     visual_campaign.ends_at
  json.domains     visual_campaign.domains
  json.markup      visual_campaign.markup
  json.updated_at  visual_campaign.updated_at
  json.created_at  visual_campaign.created_at
end
