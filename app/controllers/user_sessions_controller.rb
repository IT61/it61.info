class UserSessionsController < ApplicationController
  def create
   if @user = login(params[:email], params[:password], params[:remember_me])
      redirect_back_or_to(root_path)
    else
      flash.now[:alert] = t('.login_failed_message')
      render action: 'new'
    end
  end

  def destroy
    logout
    redirect_to root_path
  end
end
