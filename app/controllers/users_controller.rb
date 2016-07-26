# frozen_string_literal: true
class UsersController < ApplicationController
  before_action :authenticate_user!,   only: [:edit, :destroy]
  before_action :fetch_user,           only: [:show, :edit, :update, :destroy]

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
  end

  def edit
  end

  def update
    @user.assign_attributes(user_params.to_h)
    if @user.save!
      flash[:notice] = "Изменения сохранены"
    else
      flash[:error] = "Ошибка сохранения данных"
    end

    respond_with @user, location: edit_profile_path
  end

  def destroy
    # todo
  end

  private

  def show_users(scope)
    @users = User.send(scope).paginate(page: params[:page], per_page: 30)
    view = request.xhr? ? "shared/users/_list" : "users/index"
    respond_with @events do |f|
      f.html { render view, layout: !request.xhr?, locals: { users: @users } }
    end
  end

  def fetch_user
    @user = User.find(params[:id])
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
      :bio,
    ]

    params.require(:user).permit *user_attributes
  end
end
