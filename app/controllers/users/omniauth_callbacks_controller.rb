# frozen_string_literal: true
class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_filter :verify_authenticity_token

  def signin
    render "signin"
  end

  def github
    oauth_for "Github"
  end

  def facebook
    oauth_for "Facebook"
  end

  def google_oauth2
    oauth_for "Google"
  end

  def vkontakte
    oauth_for "VKontakte"
  end

  def oauth_for(kind)
    if current_user.nil?
      get_user_from_omniauth kind
    else
      add_social_to_current_user kind
    end
  end

  def failure
    redirect_to root_path
  end

  private

  def add_social_to_current_user(kind)
    current_user.add_social(request.env["omniauth.auth"])
    set_flash_message(:notice, :success, kind: kind) if is_navigational_format?
    redirect_to root_url
  end

  def get_user_from_omniauth(kind)
    @user = User.from_omniauth(request.env["omniauth.auth"])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication # this will throw if @user is not activated
      set_flash_message(:notice, :success, kind: kind) if is_navigational_format?
    else
      if @user.errors && @user.errors.messages[:email]
        flash[:error] = "You have already registered with that email with different provider"
      end
      redirect_to root_url
      # session["devise.facebook_data"] = request.env["omniauth.auth"]
    end
  end
end
