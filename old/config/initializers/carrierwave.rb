CarrierWave.configure do |config|
  config.asset_host = ActionDispatch::Http::URL.url_for(ActionController::Base.default_url_options)
end
