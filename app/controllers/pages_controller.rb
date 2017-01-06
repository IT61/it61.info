class PagesController < ApplicationController
  def welcome
    @users_count = User.count
    @events_count = Event.count
    @slack_channels_count = 42
  end

  def about
    @team = User.team
    @developers = User.developers
  end

  def thanks; end
end
