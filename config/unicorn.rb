rails_env = ENV['RAILS_ENV'] || 'production'
rails_root  = `pwd`.gsub("\n", "")

if rails_env == 'development'
  socket = "#{ENV['BOXEN_SOCKET_DIR']}/yourapp"
  preload = false
  processes = 2
else
  socket = "#{ENV['UNICORN_SOCKET_DIR']}/unicorn"
  preload = true
  processes = 6
end

pid               "#{rails_root}/tmp/pids/unicorn.pid"
stderr_path       "#{rails_root}/log/unicorn.log"
stdout_path       "#{rails_root}/log/unicorn.log"
worker_processes  processes
listen            socket, :backlog => 1024
preload_app       preload
timeout           600

after_fork do |server, worker|
  ActiveRecord::Base.establish_connection if defined?(ActiveRecord)
end
