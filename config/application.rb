require_relative "boot"

require "rails"
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
    config.load_defaults 6.0

    config.app_generators.scaffold_controller :responders_controller

    config.eager_load_paths += ["#{Rails.root}/lib"]

    config.exceptions_app = self.routes

    config.action_controller.action_on_unpermitted_parameters = :raise
    config.action_view.raise_on_missing_translations = true

    config.i18n.available_locales = [:en, :ru]
    config.i18n.load_path += Dir["#{Rails.root}/config/locales/**/*.{rb,yml}"]
    config.i18n.default_locale = :ru

    config.time_zone = ENV.fetch("TIME_ZONE", "Europe/Moscow")
  end
end
