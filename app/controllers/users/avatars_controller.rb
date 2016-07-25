# frozen_string_literal: true
class Users::AvatarsController < ApplicationController
  before_action :authenticate_user!
  before_action :fetch_user, only: [:update, :destroy]
  before_action :check_if_same_user

  def create
    avatar = avatar_params[:avatar]
    @user.avatar = avatar
    commit = @user.save
    render json: { success: commit }
  end

  def destroy
    @user.remove_avatar!
    commit = @user.save
    render json: { success: commit }
  end

  private

  def check_if_same_user_or_admin
    if @user != current_user || current_user.admin?
      raise CanCan::AccessDenied
    end
  end

  def fetch_user
    @user = User.find params[:user_id]
  end

  def avatar_params
    params.permit :avatar, :user_id
  end

end
