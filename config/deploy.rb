# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'jpmermoz.codingways.com'
set :repo_url, 'git@github.org:jpmermoz/process_manager.git'
set :deploy_to, '/var/www/jpmermoz.codingways.com'
set :keep_releases, 3
set :passenger_restart_command, 'touch'
set :passenger_restart_options, -> { "#{deploy_to}/current/tmp/restart.txt" }
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}
set :pty, false
set :sidekiq_config, -> { File.join(current_path, 'config', 'sidekiq.yml') }
set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }

# clear the default restart task
Rake::Task["deploy:restart"].clear_actions

namespace :deploy do
  
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :mkdir, '-p', "#{ release_path }/tmp"
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, 'deploy:restart'
  after :finishing, 'deploy:cleanup'
end