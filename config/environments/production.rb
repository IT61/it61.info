require Rails.root.join('config/smtp')

Rails.application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.public_file_server.enabled = ENV["RAILS_SERVE_STATIC_FILES"].present?
  config.assets.js_compressor = :uglifier
  config.assets.compile = true
  config.assets.digest = true
  config.log_level = :debug
  config.action_controller.asset_host = ENV.fetch("ASSET_HOST", ENV.fetch("APPLICATION_HOST"))
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = SMTP_SETTINGS
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.log_formatter = ::Logger::Formatter.new
  config.active_record.dump_schema_after_migration = false
  config.middleware.use Rack::CanonicalHost, ENV.fetch("APPLICATION_HOST")
  config.middleware.use Rack::Deflater
  config.public_file_server.headers = {
    "Cache-Control" => "public, max-age=3600",
  }
  config.action_mailer.default_url_options = { host: ENV.fetch("APPLICATION_HOST") }
  config.load_mini_profiler = true

  CarrierWave.configure do |config|
    config.asset_host = "https://#{ENV.fetch('APPLICATION_HOST')}"
  end
end
