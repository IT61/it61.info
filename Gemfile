source "https://rubygems.org"

ruby "3.3.1"

gem "active_link_to"
gem "autoprefixer-rails"
gem "bourbon", "7.3.0"
gem "cancancan"
gem "carrierwave", "~> 2.2.6"
gem "carrierwave-base64"
gem "config", "~> 2"
gem "devise"
gem "geocoder", "1.6.1"
gem "gravtastic"
gem "icalendar"
gem "icheck-rails"
gem "jquery-rails", "~> 4.4.0"
gem "meta-tags"
gem "mini_magick"
gem "neat", "~> 1.7.0"
gem "nenv"
gem "nokogiri"
gem "normalize-rails", "~> 4.1.1"
gem "omniauth"
gem "omniauth-github"
gem "omniauth-google-oauth2"
gem "omniauth-rails_csrf_protection"
gem "omniauth-vkontakte"
gem "pg"
gem "phony_rails", "~> 0.15.0"
gem "puma"
gem "rack-canonical-host"
gem "rails", "~> 6.1"
gem "rails-i18n", "~> 6.0"
gem "recipient_interceptor"
gem "redcarpet", "~> 3.5.1"
gem "responders"
gem "russian"
gem "sass-rails", "~> 6.0"
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
  gem "rails-assets-cropper", "~> 2.3"
  gem "rails-assets-listjs", "~> 1.5"
  gem "rails-assets-smartcrop", "~> 1.1"
end

group :development do
  gem "active_record_query_trace", require: false
  gem "listen"
  gem "seedbank", "~> 0.5"
end

group :development, :test do
  gem "amazing_print"
  gem "brakeman", require: false
  gem "bullet"
  gem "bundler-audit", ">= 0.5.0", require: false
  gem "dotenv-rails"
  gem "factory_bot_rails"
  gem "faker"
  gem "pry-byebug"
  gem "pry-rails"
  gem "rails-controller-testing"
  gem "rspec-rails"
  gem "rubocop-rails-omakase", require: false
end

group :test do
  gem "formulaic"
  gem "fuubar"
  gem "launchy"
  gem "shoulda-callback-matchers"
  gem "shoulda-matchers"
  gem "simplecov", require: false
  gem "timecop"
  gem "webmock"
end

group :staging, :production do
  gem "bootsnap", require: false
  gem "rack-timeout"
  gem "rails_stdout_logging"
end
