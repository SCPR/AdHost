require File.expand_path('../boot', __FILE__)
require 'rails/all'

Bundler.require(:default, Rails.env)

module AdHost
  class Application < Rails::Application
    config.time_zone = 'Pacific Time (US & Canada)'
    config.active_record.default_timezone = :local

    I18n.enforce_available_locales = false
    config.encoding = "utf-8"

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    config.secrets = YAML.load_file("#{Rails.root}/config/app_config.yml")[Rails.env]

    config.ffmpeg_binary = config.secrets['ffmpeg_bin']"/usr/local/bin/ffmpeg"
  end
end
