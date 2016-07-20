source "https://rubygems.org"

ruby "2.3.1"

gem "active_link_to"
gem "autoprefixer-rails"
gem "bourbon", "5.0.0.beta.5"
gem "carrierwave"
gem "cancancan"
gem "delayed_job_active_record"
gem "devise"
gem "flutie"
gem "high_voltage"
gem "json"
gem "jquery-rails"
gem "neat", "~> 1.7.0"
gem "nokogiri"
gem "normalize-rails", "~> 3.0.0"
gem "omniauth"
gem "omniauth-github"
gem "omniauth-facebook"
gem "omniauth-google-oauth2"
gem "omniauth-vkontakte"
gem "pg"
gem "phony_rails"
gem "puma"
gem "rack-canonical-host"
gem "rails", "~> 5.0.0"
gem "recipient_interceptor"
gem "redcarpet"
gem "sass-rails", "~> 5.0"
gem "slack-notifier"
gem "slim-rails"
gem "sprockets", ">= 3.0.0"
gem "sprockets-es6"
gem "suspenders"
gem "uglifier"
gem "will_paginate"
gem "activemodel-serializers-xml"

group :development do
  gem "spring"
  gem "spring-commands-rspec"
  gem "web-console"
end

group :development, :test do
  gem "awesome_print"
  gem "bullet"
  gem "bundler-audit", ">= 0.5.0", require: false
  gem "dotenv-rails"
  gem "factory_girl_rails"
  gem "pry-byebug"
  gem "pry-rails"
  gem "rspec-rails", "~> 3.5.0"
end

group :development, :staging do
  gem "rack-mini-profiler", require: false
end

group :test do
  gem "capybara-webkit"
  gem "database_cleaner"
  gem "formulaic"
  gem "fuubar"
  gem "launchy"
  gem "rails-controller-testing"
  gem "shoulda-matchers"
  gem "simplecov", require: false
  gem "timecop"
  gem "webmock"
end

group :staging, :production do
  gem "rack-timeout"
  gem "rails_stdout_logging"
end
