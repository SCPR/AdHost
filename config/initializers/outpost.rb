Outpost::Config.configure do |config|
  config.registered_models = [
    "PrerollCampaign",
    "User",
    "VisualCampaign"
  ]

  config.user_class               = "User"
  config.authentication_attribute = :username
  config.title_attributes         = [:title, :output_key]
end
