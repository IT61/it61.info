module Admin
  class EventsController < BaseController
    load_and_authorize_resource

    def index
      @events = Event.paginate(page: params[:page], per_page: 5)
    end

    def edit; end

    def update
      event_creator = EventCreator.new
      event_creator.update @event, params, current_user

      if @event.persisted?
        redirect_to admin_events_path, notice: "Данные мероприятия обновлены"
      else
        flash[:errors] = @event.errors.messages
        render :new
      end
    end

    def publish
      Event::Publisher.new(@event, current_user).publish!
      respond_with(@event)
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
