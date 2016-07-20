# frozen_string_literal: true
require_relative 'boot'

require 'rails/all'
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "sprockets/railtie"
Bundler.require(*Rails.groups)
module It61
  class Application < Rails::Application
    config.generators do |generate|
      generate.helper false
      generate.javascript_engine false
      generate.request_specs false
      generate.routing_specs false
      generate.stylesheets false
      generate.test_framework :rspec
      generate.view_specs false
    end
    config.eager_load_paths += ["#{Rails.root}/lib"]
    config.action_controller.action_on_unpermitted_parameters = :raise
    config.i18n.available_locales = [:ru]
    config.i18n.default_locale = :ru
    config.active_job.queue_adapter = :delayed_job
  end
end
