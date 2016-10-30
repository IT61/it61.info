# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'

require 'vcr'
require 'webmock/rspec'

VCR.configure do |c|
  c.allow_http_connections_when_no_cassette = true
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock
end

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].sort.each { |file| require file }

RSpec.configure do |config|
  config.include Sorcery::TestHelpers::Rails::Controller
  config.include FactoryGirl::Syntax::Methods
  config.include AbstractController::Translation

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
  end

  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.infer_base_class_for_anonymous_controllers = false

  config.order = "random"
end

ActiveRecord::Migration.maintain_test_schema!
WebMock.disable_net_connect!(allow_localhost: true)
