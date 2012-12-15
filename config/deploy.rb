require "bundler/capistrano"

server "199.229.249.151", :web, :app, :db, primary: true

set :application, "vtm"
set :user, "rails"
set :deploy_to, "/home/#{user}/www/#{application}"
set :deploy_via, :remote_cache
set :use_sudo, false

set :scm, "git"
set :repository, "git@199.229.249.151:vtmgame"
set :branch, "master"
set :rvm_ruby_string, '1.9.3@vtmgame'

require "rvm/capistrano"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

after "deploy", "deploy:cleanup" # keep only the last 5 releases

namespace :deploy do
  task :start do end
  task :stop do end
  task :restart, roles: :app, except: {no_release: true} do
    run "touch #{deploy_to}/current/tmp/restart.txt"
  end

  task :setup_config, roles: :app do
    run "mkdir -p #{shared_path}/config"
    run "mkdir -p #{shared_path}/uploads"
    run "chmod 0775 #{shared_path}/uploads"
    put File.read("config/database.yml"), "#{shared_path}/config/database.yml"
    puts "Now edit the config files in #{shared_path}."
  end
  after "deploy:setup", "deploy:setup_config"

  task :symlink_config, roles: :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
  after "deploy:finalize_update", "deploy:symlink_config"

  task :upload_link do
    run "rm -rf #{release_path}/public/uploads"
    run "ln -nfs #{shared_path}/uploads #{release_path}/public/uploads"
  end
  after "deploy", "deploy:upload_link"

  desc "Make sure local git is in sync with remote."
  task :check_revision, roles: :web do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts "WARNING: HEAD is not the same as origin/master"
      puts "Run `git push` to sync changes."
      exit
    end
  end
  before "deploy", "deploy:check_revision"
end