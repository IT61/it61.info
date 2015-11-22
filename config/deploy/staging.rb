set :rails_env, 'staging'
set :application, "new.#{fetch(:application)}"
set :branch, ENV['REVISION'] || ENV['BRANCH_NAME'] || 'site'
