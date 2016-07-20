# frozen_string_literal: true
class EventsController < ApplicationController
  respond_to :html
  respond_to :json
  respond_to :ics, only: :show
  respond_to :rss, only: :index

  before_action :authenticate_user!, except: [:index, :show, :upcoming, :past]

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
      render "new"
    end
  end

  def edit
  end

  def destroy
  end

  def participate
    @event = Event.find(params[:id])
    @event.event_participations << EventParticipation.create(user: current_user, event: @event)
    redirect_to event_path(@event)
  end

  def register
    @event = Event.find(params[:id]).decorate

    # if we have new registration...
    if request.post?
      # save participant entry form
      @participant_entry_form = ParticipantEntryForm.new(entry_form_params)
      @participant_entry_form.event = @event
      @participant_entry_form.user = current_user
      success = @participant_entry_form.save

      # if ok, mark user as participant and redirect to event page
      if success
        @event.event_participations << EventParticipation.create(user: current_user, event: @event)
        redirect_to event_path(@event)
      end
    end
  end

  def publish
  end

  private

  def entry_form_params
    params.require(:participant_entry_form).permit("reason", "profession", "suggestions", "confidence")
  end

  def unpublish
  end

  def participate
  end

  def places
    @places = Place.where("title like :title", title: "%#{params[:title]}%").limit(5)
    render json: @places.map { |p| to_yand_obj p }
  end

  private

  def show_events(scope)
    @events = Event.send(scope).published

    @no_upcoming_events_message = (@events.count == 0 and scope == :upcoming)

    @events = @events.page(params[:page]).decorate

    # TODO: Вынести верстку 'events/index' в отдельный layout
    view = request.xhr? ? 'events/_cards' : 'events/index'
    respond_with @events do |f|
      f.html { render view, layout: !request.xhr? }
    end
  end

  def redirect_to_relevant_scope
    path = Event.published.upcoming.count > 0 ? upcoming_events_path : past_events_path
    redirect_to path
  end

  def parse_date_time(event_params)
    Time.new(event_params["started_at_date(1i)"].to_i, event_params["started_at_date(2i)"].to_i, event_params["started_at_date(3i)"].to_i,
             event_params["started_at_time(4i)"].to_i, event_params["started_at_time(5i)"].to_i, event_params["started_at_time(6i)"].to_i)
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
      place_title: place.title,
    }
  end

  def event_params
    permitted_attrs = [
      :title,
      :description,
      :title_image,
      :started_at_date,
      :started_at_time,
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

    Location.where(place: place).first_or_create
  end
end
