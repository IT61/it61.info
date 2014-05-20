class UserAccountsController < ApplicationController
  respond_to :html
  responders :flash

  before_filter :prepare_user

  def edit
    @user = current_user
    respond_with @user
  end

  def update
    @user = current_user
    @user.update_attributes user_account_params

    respond_with @user, location: edit_current_account_path
  end

  private

  def prepare_user
    @user = current_user
    authorize! :manage, @user
  end

  def user_account_params
    params.require(:user).permit(:password, :password_confirmation, :current_password)
  end
end
