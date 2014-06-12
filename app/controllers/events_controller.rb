class EventsController < ApplicationController
  respond_to :html
  load_and_authorize_resource param_method: :event_params

  has_scope :ordered_desc, type: :boolean, allow_blank: true, default: true

  def index
    @events = apply_scopes(@events).decorate
    respond_with @events
  end

  def show
    @event = @event.decorate
    respond_with @event
  end

  def new
    respond_with @event
  end

  def create
    @event.organizer = current_user || nil
    @event.save

    respond_with @event
  end

  def edit
    respond_with @event
  end

  def update
    @event.update_attributes event_params
    respond_with @event
  end

  private

  def event_params
    params.require(:event).permit(:title, :description, :started_at, :published, :title_image, :place)
  end
end
