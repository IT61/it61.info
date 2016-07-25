class Admin::UsersController < ApplicationController
  layout 'admin'

  before_action :authenticate_admin!
  before_action :set_user, only: [:edit, :update]

  def index
    @users = User.paginate page: params[:page], per_page: 10
  end

  def edit
  end

  def update
    commit = @user.update user_params
    if commit
      redirect_to '/admin/users', notice: 'Данные пользователи обновлены'
    else
      flash.now[:error] = 'Не получилось обновить пользователя'
      render 'edit'
    end
  end

  private

  def set_user
    @user = User.find params[:id]
  end

  def user_params
    params.require(:user).permit :email, :first_name, :last_name, :phone, :role
  end

end
