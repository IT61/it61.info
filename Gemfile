source "https://rubygems.org"

ruby "2.5.5"

gem "active_link_to"
gem "autoprefixer-rails"
gem "bourbon", "5.0.0.beta.5"
gem "carrierwave"
gem "carrierwave-base64"
gem "cancancan"
gem "config"
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
gem "mini_magick"
gem "neat", "~> 1.7.0"
gem "nenv"
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
gem "rails", "~> 5.2"
gem "rails-i18n"
gem "recipient_interceptor"
gem "redcarpet"
gem "redis"
gem "responders"
gem "russian"
gem "sass-rails", "~> 5.0"
gem "skylight"
gem "slack-notifier"
gem "slim-rails"
gem "sprockets", ">= 3.0.0"
gem "toastr-rails"
gem "uglifier"
gem "whenever", require: false
gem "will_paginate"

# IMPORTANT: mini profiler monkey patches, so it better be required last
gem "flamegraph", require: false
gem "memory_profiler", require: false, platform: :mri
gem "rack-mini-profiler", require: false
gem "stackprof", require: false, platform: :mri

source "https://rails-assets.org" do
  gem "rails-assets-cropper"
  gem "rails-assets-smartcrop"
  gem "rails-assets-listjs"
end

group :development do
  gem "active_record_query_trace", require: false
  gem "listen"
  gem "meta_request"
end

group :development, :test do
  gem "awesome_print"
  gem "bullet"
  gem "bundler-audit", ">= 0.5.0", require: false
  gem "brakeman", require: false
  gem "dotenv-rails"
  gem "faker"
  gem "factory_bot_rails"
  gem "pry-byebug"
  gem "pry-rails"
  gem "rails-controller-testing"
  gem "rspec-rails"
  gem "standard"
end

group :test do
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
  gem "bootsnap", require: false
  gem "nakayoshi_fork"
  gem "rack-timeout"
  gem "rails_stdout_logging"
end
