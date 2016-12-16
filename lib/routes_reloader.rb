# from: https://gist.github.com/sharipov-ru/9524920
class RoutesReloader
  ROUTES_PATH = Dir.glob("config/routes/*.rb")

  def initialize(app)
    @app = app

    @routes_reloader = ActiveSupport::FileUpdateChecker.new(ROUTES_PATH) do
      Rails.application.reload_routes!
    end
  end

  def call(env)
    @routes_reloader.execute_if_updated

    @app.call(env)
  end
end
