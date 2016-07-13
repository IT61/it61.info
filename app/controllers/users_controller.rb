# frozen_string_literal: true
class UsersController < ApplicationController

  before_action :authenticate_user!, only: [:edit, :destroy]
  before_action :fetch_user, only: [:show, :edit, :update, :destroy]

  def index
    @users = User.all
  end

  def show

  end

  def edit

  end

  def update

  end

  def destroy

  end

  private

  def fetch_user
    @user = User.find(params[:id]).decorate
  end
end
