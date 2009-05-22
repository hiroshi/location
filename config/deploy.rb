set :application, "location"
set :repository,  "git://github.com/hiroshi/location"
set :deploy_to, "/var/www/location"
set :scm, :git
set :deploy_via, :remote_cache

server "silent.yakitara.com", :app, :web, :db, :primary => true
set :user, "www-data"
set :use_sudo, false
