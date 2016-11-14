require_relative "boot"

require "rails/all"

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
    config.i18n.load_path += Dir["#{Rails.root}/config/locales/**/*.{rb,yml}"]
    config.i18n.available_locales = [:ru]
    config.i18n.default_locale = :ru
    config.active_job.queue_adapter = :delayed_job
    config.exceptions_app = routes
    config.assets.paths << Rails.root.join("vendor", "assets", "components")
  end
end
