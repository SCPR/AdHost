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

    config.cache_store    = :redis_store, Rails.application.secrets['cache']
    config.audio_dir      = Rails.application.secrets['audio_dir']
    config.ffmpeg_binary  = Rails.application.secrets['ffmpeg_bin']
  end
end
