# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'rspec/autorun'

if ENV['CIRCLECI']
  FFMPEG.ffmpeg_binary = "/home/ubuntu/ffmpeg_build/ffmpeg/bin/ffmpeg"
end

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }
silence_stream(STDOUT) { TestMigration.new.up }

WebMock.disable_net_connect!

RSpec.configure do |config|
  config.use_transactional_fixtures = false
  config.filter_run focus: true
  config.order = 'random'
  config.run_all_when_everything_filtered = true

  config.include AuthenticationHelper, type: :feature
  config.include FactoryGirl::Syntax::Methods
  config.include ParamHelper
  config.include FixtureStubs

  config.before :suite do
    DatabaseCleaner.clean_with :truncation

    # We're using truncation because the audio filename contains
    # the campaign ID, so it's important that autoincrement resets
    # to 1, otherwise we'd have to rename files throughout the
    # test suite.
    DatabaseCleaner.strategy = :truncation
  end

  config.before type: :feature do
    DatabaseCleaner.strategy = :truncation
  end

  config.before :each do
    DatabaseCleaner.start
  end

  config.after :each do
    DatabaseCleaner.clean
    Rails.cache.clear
  end

  config.after :suite do
    FileUtils.rm(
      Dir[Rails.root.join(Rails.application.config.preroller.audio_dir, '*')]
    )
  end
end
