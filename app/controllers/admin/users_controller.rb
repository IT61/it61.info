module Admin
  class UsersController < BaseController
    load_and_authorize_resource

    def index
      @users = User.paginate page: params[:page], per_page: 10
    end

    def edit; end

    def update
      @user.update(user_params)
      respond_with(@user)
    end

    private

    def user_params
      attributes = [
        :id,
        :email,
        :first_name,
        :last_name,
        :phone,
        :role
      ]
      params.require(:user).permit(*attributes)
    end
  end
end
