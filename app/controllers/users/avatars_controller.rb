module Users
  class AvatarsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user, only: [:create, :update, :destroy]
    before_action :check_if_same_user_or_admin

    def create
      params[:avatar].original_filename << ".png"
      @user.avatar = avatar_params[:avatar]

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
      if @user != current_user && (not current_user.admin?)
        raise CanCan::AccessDenied
      end
    end

    def set_user
      @user = User.find(params[:user_id])
    end

    def avatar_params
      params.permit :avatar, :user_id
    end
  end
end
