# Переопределяем функции из sorcery для того, чтобы добавлять link в authentications
# и правильно сохранять аватары. Стоит немного напрячь мозг и придумать более изяшное решение.

module SorceryExternalFixes
  include ActiveSupport::Concern

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

      user = current_user.send(config.authentications_class.name.underscore.pluralize).build(hsh)
      user.save(:validate => false)
    else
      user = false
    end

    return user
  end

  def create_from(provider_name)
    sorcery_fetch_user_hash provider_name
    config = user_class.sorcery_config

    attrs = user_attrs(@provider.user_info_mapping, @user_hash)

    user_class.transaction do
      @user = user_class.new()
      attrs.each do |k,v|
        @user.send(:"#{k}=", v)
      end

      if block_given?
        return false unless yield @user
      end

      @user.save(:validate => false)

      # FIXME: С сохранением аватаров проблема невполне ясна, нужно отладить и понять,
      # почему требуется повторый вызов save, carrierwave почему то считает что картинка сохранена,
      # но на диске ее не оказывается. Проблема воспроизводится только в случае vk и github.
      @user.remote_avatar_image_url = @user_hash[:user_info][@provider.user_info_mapping[:remote_avatar_image_url]]
      @user.save(:validate => false)

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
end
