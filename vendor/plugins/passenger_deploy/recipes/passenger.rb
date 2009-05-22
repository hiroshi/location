namespace :passenger do
  desc "Let passenger application processes restart next time"
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

namespace :deploy do
  task :restart, :roles => :app, :except => { :no_release => true } do
    passenger.restart
  end
end
