module Admin
  class UsersController < BaseController
    before_action :set_user, only: [:edit, :update]

    def index
      @users = User.paginate page: params[:page], per_page: 10
    end

    def edit
    end

    def update
      commit = @user.update user_params
      if commit
        redirect_to admin_users_path, notice: "Данные пользователи обновлены"
      else
        flash.now[:error] = "Не получилось обновить пользователя"
        render "edit"
      end
    end

    private

    def set_user
      @user = User.find(user_params[:od])
    end

    def user_params
      attributes = [
        :id,
        :email,
        :first_name,
        :last_name,
        :phone,
        :role,
      ]
      params.require(:user).permit(*attributes)
    end
  end
end
