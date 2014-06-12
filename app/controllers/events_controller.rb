class EventsController < ApplicationController
  respond_to :html
  responders :flash

  load_resource param_method: :event_params
  before_filter :set_organizer, only: :create
  authorize_resource

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

  def publish
    @event.publish!
    flash[:success] = t('.success_message')
    redirect_to action: :show
  end

  def cancel_publication
    @event.cancel_publication!
    flash[:success] = t('.success_message')
    redirect_to action: :show
  end

  private

  def set_organizer
    @event.organizer = current_user || nil
  end

  def event_params
    permitted_attrs = [
      :title,
      :description,
      :started_at,
      :title_image,
      :place
    ]
    params.require(:event).permit(*permitted_attrs)
  end
end
