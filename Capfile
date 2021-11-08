# Load DSL and set up stages
require "capistrano/setup"

# Include default deployment tasks
require "capistrano/deploy"

require 'capistrano/rails'
require 'capistrano/passenger'
require 'capistrano/rbenv'
require 'capistrano/nvm'
require 'capistrano/yarn'
# require 'capistrano/sidekiq'

# install_plugin Capistrano::Sidekiq
# install_plugin Capistrano::Sidekiq::Systemd

# Load the SCM plugin appropriate to your project:
#
# require "capistrano/scm/hg"
# install_plugin Capistrano::SCM::Hg
# or
# require "capistrano/scm/svn"
# install_plugin Capistrano::SCM::Svn
# or
require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

# Include tasks from other gems included in your Gemfile
#
# For documentation on these, see for example:
#
#   https://github.com/capistrano/rvm
#   https://github.com/capistrano/rbenv
#   https://github.com/capistrano/chruby
#   https://github.com/capistrano/bundler
#   https://github.com/capistrano/rails
#   https://github.com/capistrano/passenger
#
# require "capistrano/rvm"
# require "capistrano/rbenv"
# require "capistrano/chruby"
# require "capistrano/bundler"
# require "capistrano/rails/assets"
# require "capistrano/rails/migrations"
# require "capistrano/passenger"

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }

set :rbenv_type, :user
set :rbenv_ruby, '2.6.5'

set :nvm_type, :user # or :system, depends on your nvm setup
set :nvm_node, 'v14.17.6'
set :nvm_map_bins, %w{node npm yarn webpack rake}

set :yarn_target_path, -> { release_path.join('client') }
set :yarn_flags, '--production --silent --no-progress'
set :yarn_roles, :all
set :yarn_env_variables, {}

set :default_env, {
  "PATH" => "/home/ubuntu/.nvm/versions/node/v14.17.6/bin:$PATH"
}
