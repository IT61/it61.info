class UserProfilesController < ApplicationController
  respond_to :html
  responders :flash

  before_filter :prepare_user, except: [:index, :show]

  def index
    @users = User.all
    respond_with @users
  end

  def show
    @user = User.find params[:id]
    respond_with @user
  end

  def edit
    respond_with @user
  end

  def update
    @user.update_attributes user_profile_params

    respond_with @user, location: user_profile_path(@user)
  end

  def destroy
    @user.destroy
    flash[:success] = t('.success_message', title: @user.full_name)
    notice_admins_about_user_deleting(@user)

    respond_with @user, location: user_profiles_path
  end

  private

  def prepare_user
    @user = User.find(params[:id])
    authorize! :manage, @user
  end

  def user_profile_params
    params.require(:user).permit(:first_name, :last_name, :bio,
                                 :password, :password_confirmation, :email,
                                 :avatar_image, :avatar_image_cache, :phone,
                                 :email_reminders, :sms_reminders, :subscribed)
  end

  def notice_admins_about_user_deleting(user)
    #Move to resque/delayed_job/sidekiq
    User.admins.each do |admin|
      AdminMailer.deleting_user(admin, user).deliver!
    end
  end

end
