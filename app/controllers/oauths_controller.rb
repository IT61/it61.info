class OauthsController < ApplicationController
  skip_before_filter :require_login

  def oauth
    login_at(params[:provider])
  end

  def callback
    provider = params[:provider]
    sorcery_fetch_user_hash(provider)

    logger.info '---------'
    logger.info @user_hash

    if provider.to_sym == :github
      @user_hash[:user_info]['link'] = @user_hash[:user_info]['html_url']
    end

    if provider.to_sym == :vk
      @user_hash[:user_info]['link'] = "http://vk.com/#{@user_hash[:user_info]['domain']}"
    end

    if provider.to_sym == :facebook
      @user_hash[:user_info]['avatar'] = "https://graph.facebook.com/#{@user_hash[:uid]}/picture?type=large"
    end


    if logged_in?
      # Если пользовтаель уже залогинен, привязываем к его акканту соцсеть.
      @user = current_user
      add_provider_to_user(provider)

      flash[:success] = "Аккаунт #{provider} успешно привязан к вашему профилю."
      redirect_to edit_current_profile_path
    else
      @user = login_from(provider)

      unless @user
        email = @user_hash[:user_info]['email']

        if email.present? && (@user = User.find_by(email: email))
          # Если пользователь с email-ом, пришедшим от OAuth существует, привязываем
          # к нему аккаунт соц. сети.
          auto_login(@user)

          # TODO: Тут хорошо бы действия выполнять транзакционно, если не получилось добавить
          # проавайдера к пользователю, никого не логинить, как-то оповещать об ошибках.
          add_provider_to_user(provider)
        else
          # Если пользователь с email-ом, пришедшим от OAuth не существует, создаем новго
          # пользователя.
          @user = create_from(provider)

          # if provider.to_sym == :facebook
          #   # FIXME: сделать более пристойное получение аватаров.
          #   # FIXME2: Для vk информация доступна через @user_hash
            # @user.remote_avatar_image_url = external_avatar(provider)
            # @user.save!
          # end
          @user.remote_avatar_image_url = @user_hash[:user_info][@provider.user_info_mapping[:remote_avatar_image_url]]
          @user.save(validate: false)

          reset_session
          auto_login(@user)
        end
      end
      redirect_to root_path
    end
  end


  # Переопределяем функции из sorcery для того, чтобы добавлять link в authentications
  # FIXME: Надо придумать более изящное решение, это все временно и уродство.
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


  private

  def external_avatar(provier)
  end

  def auth_params
    params.permit(:code, :provider)
  end
end
