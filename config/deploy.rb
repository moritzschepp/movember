require 'bundler/capistrano'

set :application, "movember.example.com"
set :repository,  "."

set :scm, :git
set :use_sudo, false

server 'myuser@myhost.example.com', :app, :primary => true
set :deploy_to, "/path/to/deployment"
set :deploy_via, :copy

after :deploy, :finish_up

task :finish_up do
  run "ln -sfn #{shared_path}/database.sqlite3 #{current_path}/db/production.sqlite3"
  run "ln -sfn #{shared_path}/app.yml #{current_path}/config/app.yml"
  run "ln -sfn #{shared_path}/frontpage.html.erb #{current_path}/app/views/public/_frontpage.html.erb"
  run "touch #{current_path}/tmp/restart.txt"
end
