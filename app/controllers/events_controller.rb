class EventsController < ApplicationController
  respond_to :html
  respond_to :json
  respond_to :ics, only: :show
  respond_to :rss, only: :index

  before_action :authenticate_user!, except: [:index, :show, :upcoming, :past]
  before_action :set_event, only: [:show, :edit]

  include Events

  authorize_resource

  def index
    redirect_to_relevant_scope
  end

  def upcoming
    show_events(:upcoming)
  end

  def past
    show_events(:past)
  end

  def unpublished
    show_events(:unpublished, true)
  end

  def show
    set_meta_tags og: {
      title: @event.title,
      description: MarkdownService.render_plain(@event.description),
      type: "website",
      url: event_url(@event),
      image: image_url(@event.title_image),
    }
  end

  def new
    @event ||= Event.new
    @event.build_place
  end

  def create
    @event = current_user.create_event(event_params, place_params)

    if @event.save
      flash[:success] = t("flashes.event_successfully_created")
      render json: { success: true, url: event_url(@event) }
    else
      render json: { success: false, errors: @event.errors.messages }
    end
  end

  def edit
  end

  def update
    @event = Event.find(params[:id])
    @event.assign_attributes(event_params.except(:title_image, :place))
    @event.set_place(place_params)
    if @event.save
      flash[:success] = t("flashes.event_successfully_updated")
      render json: { success: true, url: event_url(@event) }
    else
      render json: { success: false, errors: @event.errors.messages }
    end
  end

  def publish
    @event = Event.find(params[:id])
    @event.publish!
    flash[:success] = t("flashes.event_successfully_published")
    redirect_to @event
  end

  private

  def show_events(scope, include_unpublished = false)
    @events = Event.send(scope).paginate(page: params[:page], per_page: Settings.per_page.events).eager_load(:place)
    @events = @events.published unless include_unpublished
    @scope = scope

    view = request.xhr? ? "events/cards/_card" : "events/index"
    respond_with @events do |f|
      f.html { render view, layout: !request.xhr? }
    end
  end

  def set_event
    @event = Event.eager_load(:place, :organizer).find(Event.id_from_permalink(params[:id]))
  end

  def redirect_to_relevant_scope
    path = Event.published.upcoming.count.positive? ? upcoming_events_path : past_events_path
    redirect_to path
  end

  def event_params
    permitted_attrs = [
      :title,
      :description,
      :title_image,
      :link,
      :place_id,
      :organizer_id,
      :started_at,
      :has_closed_registration,
    ]
    params.require(:event).permit(*permitted_attrs)
  end

  def place_params
    place_attrs = [:title, :address, :latitude, :longitude]
    params.require(:place).permit(*place_attrs)
  end
end
