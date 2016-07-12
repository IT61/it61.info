# frozen_string_literal: true
class AccountController < ApplicationController
  before_action :authenticate_user!, except: [:sign_in]

  def sign_in

  end

  def sign_up_complete
    authenticate_user!
    redirect_to sign_in_path if current_user.nil?
  end

  def profile
    authenticate_user!
    @user = current_user.decorate
    render "users/show"
  end

  def edit
    authenticate_user!
  end

  def update
    authenticate_user!
  end
end
