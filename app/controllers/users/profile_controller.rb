module Users
  class ProfileController < ApplicationController
    before_action :authenticate_user!, except: [:sign_in]
    before_action :set_user, only: [:profile, :settings, :settings_update, :edit]

    authorize_resource class: User, except: [:sign_in, :sign_up_complete]

    
    def sign_in; end

    def sign_up_complete
      redirect_to sign_in_path if current_user.nil?
    end

    def profile
      render "users/show"
    end

    def settings; end

    # rubocop:disable Metrics/AbcSize
    def settings_update
      commit = current_user.update_attributes subscribe_params
      if commit
        flash[:success] = t("flashes.profile_settings_saved")
        redirect_to profile_settings_path
      else
        if current_user.errors.messages[:phone]
          current_user.sms_reminders = false
          current_user.save!
          flash.now[:error] = t("flashes.add_phone_for_sms_reminders")
        else
          flash.now[:error] = t("flashes.error_during_save_settings")
        end
        render "settings"
      end
    end

    def edit
      render "users/edit"
    end

    def update; end

    private

    def set_user
      @user = current_user
    end

    def subscribe_params
      params.require(:user).permit(:email_reminders, :sms_reminders, :is_social_profiles_hidden)
    end
  end
end
