class UserRegistrationsController < ApplicationController
  respond_to :html
  after_filter :subscribe_user, only: :create

  def new
    respond_with @user = User.new
  end

  def create
    @user = User.create(user_params)

    if @user.persisted?
      auto_login(@user)
      notice_admins_about_user_creating(@user)
      redirect_back_or_to(root_path)
    else
      render action: :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def subscribe_user
    @user.subscribe!
  end

  def notice_admins_about_user_creating(new_user)
    #Move all notices to resque/delayed_job/sidekiq
    User.admins.each do |admin|
      AdminMailer.adding_user(admin, new_user).deliver!
    end
  end
end
