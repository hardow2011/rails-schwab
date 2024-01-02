# config/puma.rb
environment ENV.fetch('RAILS_ENV') { 'production' }
daemonize true

app_dir = File.expand_path('../..', __FILE__)
shared_dir = "#{app_dir}/shared"

bind "unix://#{shared_dir}/sockets/puma.sock"
pidfile "#{shared_dir}/pids/puma.pid"
state_path "#{shared_dir}/pids/puma.state"
stdout_redirect "#{shared_dir}/log/puma_access.log", "#{shared_dir}/log/puma_error.log", true

workers 1 # Adjust as per your server capacity
threads 1, 6

preload_app!

on_worker_boot do
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end
