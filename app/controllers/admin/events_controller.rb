module Admin
  class EventsController < BaseController
    load_and_authorize_resource

    def index
      @events = Event.paginate(page: params[:page], per_page: 5)
    end

    def edit; end

    def update
      # TODO: Implement
    end

    def publish
      @event.publish!(current_user)
      respond_with(@event)
    end

    private

    def event_params
      params.require(:event).permit(:id)
    end
  end
end
