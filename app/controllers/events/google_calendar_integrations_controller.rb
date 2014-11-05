class Events::GoogleCalendarIntegrationsController < ApplicationController
  def create
    event = Event.find params[:event_id]
    Event::GoogleCalendarIntegration.create(event)
    redirect_to event_path(event)
  end

  def destroy
    event = Event.find params[:event_id]
    integration = Event::GoogleCalendarIntegration.new(event)
    integration.delete
    redirect_to event_path(event)
  end
end
