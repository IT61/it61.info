module Events
  class CalendarController < ApplicationController
    before_action :set_event, only: [:add, :ics]

    def add
      success = GoogleService.add_event_to_calendar(current_user, @event)

      if success
        redirect_to @event, notice: t("flashes.event_successfully_added_to_google_calendar")
      else
        redirect_to @event, error: t("flashes.event_failure_to_add_to_google_calendar")
      end
    end

    def ics
      calendar = IcsService.to_ics_calendar(@event, event_url(@event))
      options = IcsService.file_options_for(@event)
      send_data calendar, options
    end

    private

    def set_event
      @event = Event.find(event_params[:id])
    end

    def event_params
      params.require(:event).permit(:id)
    end
  end
end
