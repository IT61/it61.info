class MainPageController < ApplicationController
  def show
    @users_count = User.count
    @events_count = Event.published.count
  end
end
