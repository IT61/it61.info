class PasswordResetsController < ApplicationController
  skip_before_filter :require_login
  before_filter :ensure_user, only: [:edit, :update]

  def create
    @user = User.find_by_email(params[:email])
    @user.deliver_reset_password_instructions! if @user

    flash[:success] = t('.success_message')
    redirect_to root_url
  end

  def update
    @user.password_confirmation = params[:user][:password_confirmation]
    if @user.change_password!(params[:user][:password])
      flash[:success] = t('.success_message')
      redirect_to root_url
    else
      render 'edit'
    end
  end

  private

  def fetch_token
    @token ||= params[:id]
  end

  def fetch_user
    @user ||= User.load_from_reset_password_token(fetch_token)
  end

  def ensure_user
    not_authenticated and return if fetch_user.blank?
  end
end
