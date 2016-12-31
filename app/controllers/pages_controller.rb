class PagesController < ApplicationController
  def welcome; end

  def about
    @team = User.team
    @developers = User.developers
  end

  def thanks; end
end
