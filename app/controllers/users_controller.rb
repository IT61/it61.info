# frozen_string_literal: true
class UsersController < ApplicationController
  before_action :authenticate_user!,   only: [:edit, :destroy]
  before_action :fetch_user,           only: [:show, :edit, :update, :destroy]

  respond_to :html

  load_and_authorize_resource

  def index
    @users = User.all
  end

  def show
  end

  def edit
  end

  def update
    # commit = @user.update user_params
    @user.assign_attributes first_name: user_params[:first_name],
                            last_name: user_params[:last_name],
                            email: user_params[:email],
                            phone: user_params[:phone],
                            bio: user_params[:bio]
    @user.save
    if @user.valid?
      flash[:notice] = "Изменения сохранены"
      respond_with @user, location: edit_path
    else
      flash[:error] = "Ошибка сохранения данных"
      respond_with @user, location: edit_path
    end
  end

  def destroy
    # todo
  end

  private

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
      :bio
    ]

    params.require(:user).permit *user_attributes
  end

end
