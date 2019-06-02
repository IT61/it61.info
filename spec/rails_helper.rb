if ENV.fetch("COVERAGE", false)
  require "simplecov"

  SimpleCov.profiles.define "coverage" do
    load_profile "rails"
    # Don't include vendored stuff
    add_filter ".vendor"
    add_filter "lib/tasks"

    add_group "Uploaders", "app/uploaders"
  end

  if ENV["CIRCLE_ARTIFACTS"]
    dir = File.join(ENV["CIRCLE_ARTIFACTS"], "coverage")
    SimpleCov.coverage_dir(dir)
  end

  SimpleCov.start "coverage"
end

ENV["RAILS_ENV"] ||= "test"

require File.expand_path("../../config/environment", __FILE__)

require "rspec/rails"
require "cancan/matchers"
require "webmock/rspec"

Dir[Rails.root.join("spec/support/**/*.rb")].sort.each { |file| require file }

module Features
  # Extend this module in spec/support/features/*.rb
  include Formulaic::Dsl
end

RSpec.configure do |config|
  config.include Features, type: :feature
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.extend ControllerMacros, type: :controller
  config.infer_base_class_for_anonymous_controllers = false
  config.infer_spec_type_from_file_location!
  config.use_transactional_fixtures = true

  config.expect_with :rspec do |expectations|
    expectations.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
  end

  config.example_status_persistence_file_path = "tmp/rspec_examples.txt"
  config.order = :random
end

WebMock.disable_net_connect!(allow_localhost: true)

ActiveRecord::Migration.maintain_test_schema!
