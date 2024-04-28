class UsersController < ApplicationController
  before_action :authenticate_user!, only: [ :edit, :destroy ]

  respond_to :html
  load_and_authorize_resource

  def active
    show_users(:active)
  end

  def recent
    show_users(:recent)
  end

  def index
    show_users(:active)
  end

  def show
    @events = @user.owner_of_events
  end

  def edit; end

  def update
    commit = @user.update_with_fresh(user_params)

    if commit
      flash[:notice] = t("flashes.profile_saved")
    else
      flash[:error] = t("flashes.error_during_save_settings")
    end

    respond_with @user, location: edit_profile_path
  end

  def destroy; end

  private

  def show_users(scope)
    @total = User.count
    @users = User.send(scope).presentable.paginate(page: params[:page], per_page: Settings.per_page.users)
    template = request.xhr? ? "users/_list" : "users/index"
    respond_with @events do |f|
      f.html { render template, layout: !request.xhr?, locals: { users: @users } }
    end
  end

  def user_params
    user_attributes = [
      :first_name,
      :last_name,
      :company_name,
      :company_site,
      :company_position,
      :email,
      :phone,
      :hash_tag,
      :bio
    ]

    params.require(:user).permit(*user_attributes)
  end
end
