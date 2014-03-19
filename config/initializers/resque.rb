# Every time a job is started, make sure the connection
# to MySQL is okay. This avoids the "MySQL server has gone away"
# error.
Resque.redis = "localhost:6379"

Resque.after_fork = Proc.new {
  ActiveRecord::Base.verify_active_connections!
}
