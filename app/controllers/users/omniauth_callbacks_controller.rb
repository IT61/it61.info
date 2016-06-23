class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  skip_before_filter :verify_authenticity_token

  def github
    oauth_for 'Github'
  end

  def facebook
    oauth_for 'Facebook'
  end

  def google_oauth2
    oauth_for 'Google'
  end

  def vkontakte
    oauth_for 'VKontakte'
  end

  def oauth_for(kind)
    @user = User.from_omniauth(request.env["omniauth.auth"])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication # this will throw if @user is not activated
      set_flash_message(:notice, :success, kind: kind) if is_navigational_format?
    else
      if @user.errors and @user.errors.messages[:email]
        flash[:error] = 'You have already registered with that email with different provider'
      end
      redirect_to root_url
      # session["devise.facebook_data"] = request.env["omniauth.auth"]
    end
  end

  def failure
    redirect_to root_path
  end
end
