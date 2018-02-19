I18n.load_path += Dir["#{Rails.root}/config/locales/**/*.{rb,yml}"]
I18n.available_locales = [:en, :ru]
I18n.default_locale = :ru
