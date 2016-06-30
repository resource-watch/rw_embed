workers Integer(ENV['WEB_CONCURRENCY'] || 0)
# Min and Max threads per worker
threads_count = Integer(ENV['RAILS_MAX_THREADS'] || 5)
threads threads_count, threads_count

preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 3015
environment ENV['RACK_ENV'] || 'development'

# # Set master PID and state locations
pidfile    'tmp/pids/puma.pid'
state_path 'tmp/pids/puma.state'

on_worker_boot do
  ActiveRecord::Base.establish_connection
end
