# frozen_string_literal: true
class UsersController < ApplicationController

  before_action :authenticate_user!, only: [:edit, :destroy]

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id]).decorate
  end

  def edit

  end

  def destroy

  end

end
