module Admin
  class EventsController < ApplicationController
    layout "admin"
    before_action :authenticate_admin!
    before_action :set_event, only: [:edit, :update]

    def index
      @events = Event.paginate page: params[:page], per_page: 5
    end

    def edit
    end

    def update
      event_creator = EventCreator.new
      event_creator.update @event, params, current_user

      if @event.persisted?
        redirect_to admin_events_path, notice: "Данные мероприятия обновлены"
      else
        flash[:errors] = @event.errors.messages
        render "new"
      end
    end

    private

    def set_event
      @event = Event.find params[:id]
    end
  end
end
