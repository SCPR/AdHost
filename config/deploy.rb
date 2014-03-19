require "bundler/capistrano"
require 'new_relic/recipes'

set :application, "Audiobox"
set :scm, :git
set :repository,  "git@github.com:SCPR/Audiobox.git"
set :branch, "master"
set :scm_verbose, true
set :deploy_via, :remote_cache

set :deploy_to, "/web/audiobox"
set :rails_env, "production"
set :user, "audiobox"
set :use_sudo, false

media   = "66.226.4.228"
staging = "66.226.4.241"

role :app, media
role :web, media
role :db,  media, :primary => true

task :staging do
  roles.clear
  set :rails_env, :scprdev
  set :branch, "master"
  role :app, staging
  role :web, staging
  role :db,  staging, :primary => true
end

before "deploy:create_symlink", "deploy:symlink_config"
after "deploy:restart", "newrelic:notice_deployment"

namespace :deploy do
  task :start, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  task :stop, :roles => :app do
    # Do nothing.
  end

  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_release}/tmp/restart.txt"
  end

  task :symlink_config do
    %w{ database.yml app_config.yml newrelic.yml }.each do |file|
      run "ln -nfs #{shared_path}/config/#{file} #{release_path}/config/#{file}"
    end
  end

end
