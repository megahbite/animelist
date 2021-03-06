# config valid only for current version of Capistrano
lock "3.8.1"

set :application, "animelist-rails"
set :repo_url, "https://github.com/megahbite/animelist.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/srv/animelist-rails"

set :rbenv_type, :user
set :rbenv_ruby, "2.4.1"

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
append :linked_files, "config/database.yml", "config/secrets.yml", "config/app_config.yml"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

set :puma_workers, 2
set :puma_preload_app, true
set :puma_init_active_record, true
set :puma_env, :production
set :nginx_server_name, "xxanime.megan.moe"
set :nginx_use_ssl, true

set :conditionally_migrate, true
