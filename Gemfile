source "https://rubygems.org"

ruby "2.3.3"

gem "active_link_to"
gem "autoprefixer-rails"
gem "bourbon", "5.0.0.beta.5"
gem "carrierwave"
gem "cancancan"
gem "config"
gem "delayed_job_active_record"
gem "devise"
gem "flutie"
gem "geocoder"
gem "google-api-client", "~> 0.8.2", require: "google/api_client"
gem "gravtastic"
gem "high_voltage"
gem "icalendar"
gem "icheck-rails"
gem "jquery-rails"
gem "meta-tags"
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
gem "rails-i18n"
gem "recipient_interceptor"
gem "redcarpet"
gem "redis"
gem "responders"
gem "rollbar"
gem "russian"
gem "sass-rails", "~> 5.0"
gem "slack-notifier"
gem "slim-rails"
gem "sprockets", ">= 3.0.0"
gem "sprockets-es6"
gem "suspenders"
gem "toastr-rails"
gem "uglifier"
gem "will_paginate"

source "https://rails-assets.org" do
  gem "rails-assets-cropper"
  gem "rails-assets-smartcrop"
  gem "rails-assets-listjs"
end

group :development do
  gem "listen"
  gem "meta_request"
  gem "spring"
  gem "spring-commands-rspec"
end

group :development, :test do
  gem "awesome_print"
  gem "bullet"
  gem "bundler-audit", ">= 0.5.0", require: false
  gem "brakeman", require: false
  gem "dotenv-rails"
  gem "forgery"
  gem "factory_girl_rails"
  gem "pry-byebug"
  gem "pry-rails"
  gem "rails-controller-testing"
  gem "rspec-rails", "~> 3.5.0"
  gem "scss_lint", require: false
end

group :development, :staging do
  gem "rack-mini-profiler", require: false
end

group :test do
  gem "database_cleaner"
  gem "formulaic"
  gem "fuubar"
  gem "launchy"
  gem "shoulda-matchers"
  gem "shoulda-callback-matchers"
  gem "simplecov", require: false
  gem "timecop"
  gem "webmock"
end

group :staging, :production do
  gem "rack-timeout"
  gem "rails_stdout_logging"
end
