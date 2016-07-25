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
    @event = Event.find(params[:id])
  end

  def new
    @event ||= Event.new
  end

  def create
    event_creator = EventCreator.new
    @event = event_creator.create params, current_user

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
    if @event.opened? || @event.past?
      @event.event_participations << EventParticipation.create(user: current_user, event: @event)
    end
    redirect_to event_path(@event)
  end

  def register
    @event = Event.find(params[:id])

    # there is no business if event have open registration
    return redirect_to event_path(@event) unless @event.closed?

    # if user already have some entry form for this event...
    @participant_entry_form = ParticipantEntryForm.where(user_id: current_user.id, event_id: @event.id).first_or_initialize

    # if we have new registration...
    if request.post?
      # save participant entry form
      @participant_entry_form.event = @event
      @participant_entry_form.user = current_user
      @participant_entry_form.update(entry_form_params)
      success = @participant_entry_form.save

      # if ok, mark user as participant and redirect to event page
      if success
        @event.event_participations << EventParticipation.create(user: current_user, event: @event)
        redirect_to event_path(@event)
      end
    end
  end

  def revoke_participation
    @event = Event.find(params[:id])
    participation = @event.participation_for(current_user)
    EventParticipation.destroy(participation) unless participation.blank?
    redirect_to event_path(@event)
  end

  def publish
  end

  def unpublish
  end

  def places
    @places = Place.where("title like :title", title: "%#{params[:title]}%").limit(5)
    render json: @places.map { |p| to_yand_obj p }
  end

  private

  def entry_form_params
    params.require(:participant_entry_form).permit("reason", "profession", "suggestions", "confidence")
  end

  def show_events(scope)
    @events = Event.send(scope).published

    @no_upcoming_events = (@events.count == 0 and scope == :upcoming)
    @events = @events.paginate(page: params[:page], per_page: 6)

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
end
