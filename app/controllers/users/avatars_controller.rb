# frozen_string_literal: true
class Users::AvatarsController < ApplicationController

  before_action :authenticate_user!
  before_filter :fetch_user, only: [:update, :destroy]
  before_filter :check_if_same_user

  def create
    avatar = avatar_params[:avatar]
    current_user.avatar = avatar
    commit = current_user.save
    render json: {success: commit}
  end

  def destroy
    current_user.remove_avatar!
    commit = current_user.save
    render json: {success: commit}
  end

  private

  def check_if_same_user
    if @user != current_user
      # render_403
    end
  end

  def fetch_user
    @user = User.find params[:user_id]
  end

  def avatar_params
    params.permit :avatar, :user_id
  end
end
