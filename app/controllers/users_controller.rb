# frozen_string_literal: true
class UsersController < ApplicationController
  before_action :authenticate_user!,   only: [:edit, :destroy]
  before_action :fetch_user,           only: [:show, :edit, :update, :destroy]

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
    @user.assign_attributes first_name: user_params[:first_name], last_name: user_params[:last_name],
                            email: user_params[:email], phone: user_params[:phone], bio: user_params[:bio]
    @user.save
    if @user.valid?
      flash.now[:notice] = "Изменения сохранены"
      render "edit"
    else
      flash.now[:error] = "Ошибка сохранения данных"
      render "edit"
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
    params.require(:user).permit :first_name, :last_name,
                                 :company_name, :company_site, :company_position,
                                 :email, :phone, :hash_tag, :bio
  end
end
