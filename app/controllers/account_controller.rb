# frozen_string_literal: true
class AccountController < ApplicationController
  before_action :authenticate_user!, except: [:sign_in]
  before_action :fetch_user, only: [:profile, :settings, :edit]

  def sign_in
  end

  def sign_up_complete
    redirect_to sign_in_path if current_user.nil?
  end

  def profile
    render "users/show"
  end

  def settings
  end

  def edit
    render "users/edit"
  end

  def update
  end

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
      fetch_user
      render "settings"
    end
  end

  private

  def fetch_user
    @user = current_user
  end

  def subscribe_params
    params.require(:user).permit :email_reminders, :sms_reminders
  end
end
