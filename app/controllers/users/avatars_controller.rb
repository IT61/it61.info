module Users
  class AvatarsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_user, only: [:create, :update, :destroy]
    before_action :check_if_same_user_or_admin

    def create
      avatar = avatar_params[:avatar]

      # Create temporary .png file for creating image
      tmpfile = Dir::Tmpname.make_tmpname(["blob", ".png"], nil)
      fpath = Rails.root.join("tmp", tmpfile)
      File.open(fpath, "wb") do |f|
        f.write(avatar.read)
        @user.avatar = f
      end
      commit = @user.save

      # Delete temporary file after usage
      File.delete(fpath)

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
