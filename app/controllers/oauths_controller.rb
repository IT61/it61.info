class OauthsController < ApplicationController
  skip_before_filter :require_login

  def oauth
    login_at(params[:provider])
  end

  def callback
    provider = params[:provider]
    @user = login_from(provider)

    unless @user
      sorcery_fetch_user_hash(provider)
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

        # FIXME: сделать более пристойное получение аватаров
        @user.remote_avatar_image_url = external_avatar(provider)
        @user.save!

        reset_session
        auto_login(@user)
      end
    end

    redirect_to root_path
  end

  private

  def external_avatar(provier)
    if provier.to_sym == :facebook
      "https://graph.facebook.com/#{@user_hash[:uid]}/picture?type=large"
    end
  end

  def auth_params
    params.permit(:code, :provider)
  end
end
