Rails.application.configure do
  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      "Cache-Control" => "public, max-age=172800",
    }
  else
    config.action_controller.perform_caching = false
    config.cache_store = :null_store
  end
  config.action_mailer.perform_caching = false
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = { host: "localhost:3000" }

  if Nenv.use_mailcatcher?
    config.action_mailer.delivery_method = :smtp
    config.action_mailer.smtp_settings = { host: "localhost:3000", port: 1025 }
  end

  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.assets.debug = true
  config.assets.digest = true
  config.assets.raise_runtime_errors = true
  config.assets.quiet = true
  config.action_view.raise_on_missing_translations = true

  config.load_mini_profiler = ENV["ENABLE_MINI_PROFILER"]
  config.use_query_trace = ENV["ENABLE_QUERY_TRACE"]

  config.after_initialize do
    Bullet.enable = true
    Bullet.bullet_logger = true
    Bullet.rails_logger = true
  end

  if Nenv.enable_routes_reloader?
    config.middleware.use RoutesReloader
  end
end
