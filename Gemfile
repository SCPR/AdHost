source 'https://rubygems.org'

gem 'rails', '~> 3.2.17'
gem 'mysql2'
gem 'bcrypt-ruby', '~> 3.0.0'
gem 'newrelic_rpm'
gem 'capistrano', '~> 2.15.0'
gem 'jquery-rails', '~> 3.1.0'
gem 'jbuilder', '~> 2.0.4'
gem 'resque', '~> 1.25.2'
gem 'carrierwave', '~> 0.10.0'

gem 'outpost-cms', github: 'SCPR/outpost'
#gem 'outpost-cms', path: "#{ENV['PROJECT_HOME']}/outpost"
gem 'select2-rails', '3.4.1'

gem 'simple_form', '~> 2.1.1'
gem 'kaminari', github: "amatsuda/kaminari"
gem "streamio-ffmpeg", git: "git://github.com/SCPR/streamio-ffmpeg.git"

gem "redis-store", '~> 1.1.4'


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'eco', '~> 1.0.0'
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'therubyracer'
  gem 'uglifier', '>= 1.0.3'
  gem 'bootstrap-sass', '~> 2.2'
end

group :development do
  gem "dbsync", github: 'bricker/dbsync'
  gem 'guard'
  gem 'guard-resque'
  gem 'guard-rspec'
end

group :test do
  gem 'rspec-rails', '~> 2.12'
  gem 'factory_girl_rails'
  gem 'database_cleaner'
  gem 'capybara', "~> 2.0"
  gem 'pry'
  gem 'webmock'
end
