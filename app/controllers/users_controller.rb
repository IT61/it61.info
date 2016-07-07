class UsersController < ApplicationController

  def show
    @user = User.find(params[:id]).decorate
  end
end
