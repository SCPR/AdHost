Resque.redis = "#{Rails.application.secrets["resque"]}/adhost-#{Rails.env}"

Resque.after_fork do |job|
  # Every time a job is started, make sure the connection
  # to MySQL is okay. This avoids the "MySQL server has gone away"
  # error.
  ActiveRecord::Base.connection_pool.connections.each(&:verify!)
end
