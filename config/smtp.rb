SMTP_SETTINGS = {
  address: ENV["SMTP_ADDRESS"], # example: "smtp.sendgrid.net"
  authentication: :plain,
  domain: ENV["SMTP_DOMAIN"], # example: "heroku.com"
  enable_starttls_auto: true,
  password: ENV["SMTP_PASSWORD"],
  port: "587",
  user_name: ENV["SMTP_USERNAME"],
  openssl_verify_mode: "none"
}.freeze

if ENV["EMAIL_RECIPIENTS"].present?
  Mail.register_interceptor RecipientInterceptor.new(ENV["EMAIL_RECIPIENTS"])
end
