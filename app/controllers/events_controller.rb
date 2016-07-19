class EventsController < ApplicationController
  respond_to :html
  respond_to :json
  respond_to :ics, only: :show
  respond_to :rss, only: :index

  before_action :authenticate_user!, except: [:index, :show]

  authorize_resource

  def index
    return show_correct_scope if params[:scope].nil?

    @events = Event.send(params[:scope])
    @events = @events.published if current_user.member?

    @no_upcoming_events_message = (@events.count == 0 and params[:scope] == :upcoming)

    @events = @events.page(params[:page]).decorate

    # TODO: Вынести верстку 'events/index' в отдельный layout
    view = request.xhr? ? 'events/_cards' : 'events/index'
    respond_with @events do |f|
      f.html { render view, layout: !request.xhr? }
    end
  end

  def show

  end

  def new
    @event ||= Event.new
  end

  def create
    ep = event_params
    @event = Event.create do |e|
      e.title = ep[:title]
      e.title_image = ep[:title_image]
      e.description = ep[:description]
      e.started_at = parse_date_time ep
      e.organizer = current_user
      e.locations += [new_location_with_place]
    end

    if @event.persisted?
      redirect_to event_path(@event)
    else
      flash[:errors] = @event.errors.messages
      render 'new'
    end
  end

  def edit

  end

  def destroy

  end

  def publish

  end

  def unpublish

  end

  def participate

  end

  def places
    @places = Place.where('title like :title and address like :address', title: "%#{params[:title]}%", address: "%#{params[:address]}%").limit(5)
    render json: @places.map { |p| to_yand_obj p }
  end

  private

  def parse_date_time(event_params)
    Time.new(event_params['started_at_date(1i)'].to_i, event_params['started_at_date(2i)'].to_i, event_params['started_at_date(3i)'].to_i,
             event_params['started_at_time(4i)'].to_i, event_params['started_at_time(5i)'].to_i, event_params['started_at_time(6i)'].to_i)
  end
  
  def show_correct_scope
    path = Event.published.upcoming.count > 0 ? upcoming_events_path : past_events_path
    redirect_to path
  end

  def to_yand_obj(place)
    {
        meta: {
            text: place.address,
        },
        coordinates: [place.latitude, place.longitude],
        place_title: place.title
    }
  end

  def event_params
    permitted_attrs = [
        :title,
        :description,
        :title_image,
        :started_at_date,
        :started_at_time,
        :extra_info,
        :place_title,
        :address,
        :latitude,
        :longitude,
    ]
    params.require(:event).permit(*permitted_attrs)
  end

  def new_location_with_place
    place = Place.where(title: event_params[:place_title], address: event_params[:address],
                        latitude: event_params[:latitude], longitude: event_params[:longitude]).first_or_create

    Location.where(extra_info: event_params[:extra_info], place: place).first_or_create
  end
end
