class Events::AttendeesController < ApplicationController
  respond_to :html
  respond_to :csv, only: [:index]
  load_and_authorize_resource :event
  authorize_resource class: false
  skip_authorize_resource only: :index

  def index
    @attendees = @event.attendees.order(last_name: :asc)
    respond_to do |format|
      format.html { render nothing: true }
      format.csv { send_data @attendees.to_csv, filename: "attendees.csv" }
    end
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
