class Events::VisitsController < ApplicationController
  before_action :set_event

  def index
    @participants
  end

  def mark
    p = @event.participation_for(User.find(params[:user_id]))
    p.visited = params[:visited]
    p.save
  end

  def set_event
    @event = Event.where(secret_word: params[:hash]).find(Event.id_from_permalink(params[:id]))
  end
end
