class Events::AttendeesController < ApplicationController
  respond_to :html
  load_and_authorize_resource :event
  skip_authorize_resource only: :index

  def index
    @attendees = @event.attendees
  end

  def create
    @event.attendees << current_user
    respond_with(@event)
  end

  def destroy
    @event.attendees.delete(current_user)
    respond_with(@event)
  end
end
