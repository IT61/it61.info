class UserRegistrationsController < ApplicationController
  respond_to :html

  def new
    respond_with @user = User.new
  end

  def create
    @user = User.create(user_params)

    if @user.persisted?
      auto_login(@user)
      redirect_back_or_to(root_path)
    else
      render action: :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
