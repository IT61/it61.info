# frozen_string_literal: true
class UsersController < ApplicationController

  before_action :authenticate_user!,   only: [:edit, :destroy]
  before_action :fetch_user,           only: [:update, :update_avatar, :destroy_avatar, :destroy]
  before_action :fetch_decorated_user, only: [:show, :edit]

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
      @user = @user.decorate
      flash.now[:notice] = 'Изменения сохранены'
      render 'edit'
    else
      @user = @user.decorate
      flash.now[:error] = 'Ошибка сохранения данных'
      render 'edit'
    end
  end

  # ajax call
  def update_avatar
    avatar = avatar_params[:avatar]
    @user.avatar = avatar
    commit = @user.save
    if commit
      render json: {success: true}
    else
      render json: {success: false}
    end
  end

  def destroy_avatar
    # if @user != current_user
    #   render_403
    # else
    @user.remove_avatar!
    commit = @user.save
      if commit
        render json: {success: true}
      else
        render json: {success: false}
      end
    # end
  end

  def destroy

  end

  private

  def fetch_user
    @user = User.find(params[:id])
  end

  def fetch_decorated_user
    @user = User.find(params[:id]).decorate
  end

  def user_params
    params.require(:user).permit :first_name, :last_name,
      :company_name, :company_site, :company_position,
      :email, :phone, :hash_tag, :bio
  end

  def avatar_params
    params.permit(:avatar, :id)
  end
end
