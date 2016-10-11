module Users
  class OmniauthController < Devise::OmniauthCallbacksController
    skip_before_action :verify_authenticity_token

    def github
      oauth_for "Github"
    end

    def facebook
      oauth_for "Facebook"
    end

    def google_oauth2
      oauth_for "Google"

      if user_signed_in?
        current_user.update_attributes(
          google_refresh_token: request.env["omniauth.auth"]["credentials"]["refresh_token"]
        )
      end
    end

    def vkontakte
      oauth_for "VKontakte"
    end

    def oauth_for(kind)
      if current_user.nil?
        create_user_from_omniauth kind
      else
        add_social_to_current_user kind
      end
    end

    private

    def add_social_to_current_user(kind)
      current_user.add_social(request.env["omniauth.auth"])
      set_flash_message(:notice, :success, kind: kind) if is_navigational_format?
      redirect_to edit_profile_path
    end

    def create_user_from_omniauth(_kind)
      auth = request.env["omniauth.auth"]

      @user = User.from_omniauth(auth)

      if @user.valid?
        SocialAccount.from_omniauth(auth, @user)
        SlackService.invite(@user)

        @user.save
        sign_in_and_redirect @user
      else
        if @user.errors && @user.errors.messages[:email]
          flash[:error] = t("flashes.user.failure.email")
        else
          flash[:error] = t("flashes.user.failure.something_is_wrong")
        end
        redirect_to root_url
      end
    end
  end
end
