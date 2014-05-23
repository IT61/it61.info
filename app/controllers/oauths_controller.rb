class OauthsController < ApplicationController
  skip_before_filter :require_login

  def oauth
    login_at(params[:provider])
  end

  def callback
    provider = params[:provider]
    sorcery_fetch_user_hash(provider)
    fix_user_hash!

    if logged_in?
      add_authentication_to_current_user!
      redirect_to edit_current_profile_path
    else
      create_new_user_or_add_authentication_to_existing_by_email!
      redirect_to root_path
    end
  end

  private

  def fix_user_hash!
    if provider.to_sym == :github
      @user_hash[:user_info]['link'] = @user_hash[:user_info]['html_url']
    end

    if provider.to_sym == :vk
      @user_hash[:user_info]['link'] = "http://vk.com/#{@user_hash[:user_info]['domain']}"
    end

    if provider.to_sym == :facebook
      @user_hash[:user_info]['avatar'] = "https://graph.facebook.com/#{@user_hash[:uid]}/picture?type=large"
    end
  end

  def add_authentication_to_current_user!
    @user = current_user
    add_provider_to_user(provider)

    flash[:success] = t('sorcery_external.success', provider: provider)
  end

  def create_new_user_or_add_authentication_to_existing_by_email!
    @user = login_from(provider)

    unless @user
      email = @user_hash[:user_info]['email']

      if email.present? && (@user = User.find_by(email: email))
        auto_login(@user)
        add_provider_to_user(provider)
      else
        @user = create_from(provider)
        reset_session
        auto_login(@user)
      end
    end
  end

  def auth_params
    params.permit(:code, :provider)
  end
end
