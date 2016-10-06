class Events::IntegrationsController < ApplicationController
  respond_to :json
  respond_to :ics, only: :show
  respond_to :rss, only: :index

  before_action :set_event, only: [:add_to_google_calendar, :download_ics_file]

  def add_to_google_calendar
    success = GoogleService.add_event_to_calendar(current_user, @event)

    if success
      redirect_to @event, notice: t("flashes.event_successfully_added_to_google_calendar")
    else
      redirect_to @event, error: t("flashes.event_failure_to_add_to_google_calendar")
    end
  end

  def download_ics_file
    calendar = IcsService.to_ics_calendar(@event, event_url(@event))
    options = IcsService.file_options_for(@event)
    send_data calendar, options
  end

  def set_event
    @event = Event.find(params[:id])
  end
end
