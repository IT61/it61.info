# Переопределяем функции из sorcery для того, чтобы добавлять link в authentications
# и правильно сохранять аватары.
module SorceryExternalFixes
  extend ActiveSupport::Concern

  def add_provider_to_user(provider_name)
    sorcery_fetch_user_hash provider_name
    config = user_class.sorcery_config

    # first check to see if user has a particular authentication already
    unless (current_user.send(config.authentications_class.name.underscore.pluralize).send("find_by_#{config.provider_attribute_name}_and_#{config.provider_uid_attribute_name}", provider_name, @user_hash[:uid].to_s))
      hsh = {
        config.provider_uid_attribute_name => @user_hash[:uid],
        config.provider_attribute_name => provider_name.to_s,
        link: @user_hash[:user_info]['link']
      }

      auth = current_user.send(config.authentications_class.name.underscore.pluralize).build(hsh)
      auth.save(validate: false)

      # Пытаемся заполнить недостающие поля в профиле пользователя.
      apply_user_info_if_not_exists! current_user
    else
      auth = false
    end

    return auth
  end

  def create_from(provider_name)
    sorcery_fetch_user_hash provider_name
    config = user_class.sorcery_config

    user_class.transaction do
      @user = user_class.new()
      apply_user_info_if_not_exists!(@user)

      hsh = {
        config.authentications_user_id_attribute_name => @user.id,
        config.provider_attribute_name => provider_name,
        config.provider_uid_attribute_name => @user_hash[:uid],
        link: @user_hash[:user_info]['link']
      }

      user_class.sorcery_config.authentications_class.create!(hsh)
    end
    @user
  end

  # Переопределяем метод sorcery для того, чтобы подтягивать недостающую информацию (аватары и т.п.)
  # при логине. Нужно для того, чтобы подтянулась информация пользователей, портированных из старой базы.
  def login_from(provider_name, should_remember = false)
    sorcery_fetch_user_hash provider_name

    if user = user_class.load_from_provider(provider_name, @user_hash[:uid].to_s)
      apply_user_info_if_not_exists! user

      # Пытаемся добавить ссылку на профиль пользователя в соцсети если не заполнена.
      auth = user.authentications.find_by(provider: provider_name)
      unless auth.link
        auth.link = @user_hash[:user_info]['link']
        auth.save!
      end

      # we found the user.
      # clear the session
      return_to_url = session[:return_to_url]
      reset_sorcery_session
      session[:return_to_url] = return_to_url

      # sign in the user
      auto_login(user, should_remember)
      after_login!(user)

      # return the user
      user
    end
  end

  def apply_user_info_if_not_exists!(user)
    attrs = user_attrs(@provider.user_info_mapping, @user_hash)
    attrs.each do |k, v|
      if k.to_sym == :remote_avatar_image_url
        user.remote_avatar_image_url = v unless user.avatar_image.present?
      else
        user.send(:"#{k}=", v) unless user.send(k).present?
      end
    end
    user.save(validate: false)

    # FIXME: С сохранением аватаров проблема невполне ясна, нужно отладить и понять,
    # почему требуется повторый вызов save, carrierwave почему то считает что картинка сохранена,
    # но на диске ее не оказывается. Проблема воспроизводится только в случае vk и github.
    if user.avatar_image_changed? && user.avatar_image.present?
      user.remote_avatar_image_url = @user_hash[:user_info][@provider.user_info_mapping[:remote_avatar_image_url]]
      user.save(validate: false)
    end
  end
end
