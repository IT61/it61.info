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

  def avatar_params
    params.permit(:avatar, :id)
  end
end
