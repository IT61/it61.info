Devise.setup do |config|
  config.secret_key = ENV["SECRET_KEY_BASE"]
  config.mailer_sender = "no-reply@it61.info"

  require "devise/orm/active_record"
  config.authentication_keys = [:name]
  config.case_insensitive_keys = [:email]
  config.strip_whitespace_keys = [:email]
  config.skip_session_storage = [:http_auth]
  config.stretches = Rails.env.test? ? 1 : 11
  config.reconfirmable = false
  config.expire_all_remember_me_on_sign_out = true
  config.password_length = 6..128
  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/
  config.reset_password_keys = [:email]
  config.reset_password_within = 6.hours
  config.sign_out_via = :delete

  # OmniAuth
  config.omniauth :github,
                  Rails.application.secrets.github_key,
                  Rails.application.secrets.github_secret,
                  scope: "user:email"

  config.omniauth :facebook,
                  Rails.application.secrets.facebook_key,
                  Rails.application.secrets.facebook_secret,
                  scope: "email"

  config.omniauth :vkontakte,
                  Rails.application.secrets.vkontakte_key,
                  Rails.application.secrets.vkontakte_secret,
                  scope: "email"

  config.omniauth :google_oauth2,
                  Rails.application.secrets.google_key,
                  Rails.application.secrets.google_secret,
                  scope: "email https://www.googleapis.com/auth/calendar",
                  access_type: "offline",
                  prompt: "consent"

  config.warden do |manager|
    manager.failure_app = Users::ProfileController.action(:sign_in)
  end
end
