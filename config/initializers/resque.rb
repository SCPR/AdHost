Resque.redis = "localhost:6379/6"

Resque.after_fork do |job|
  # Every time a job is started, make sure the connection
  # to MySQL is okay. This avoids the "MySQL server has gone away"
  # error.
  ActiveRecord::Base.connection_pool.connections.each(&:verify!)
end
