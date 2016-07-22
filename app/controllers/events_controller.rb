# frozen_string_literal: true
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

    @no_upcoming_events_message = (@events.count == 0 && params[:scope] == :upcoming)

    @events = @events.page(params[:page])

    # TODO: Вынести верстку 'events/index' в отдельный layout
    view = request.xhr? ? "events/_cards" : "events/index"
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
    @event.event_participations << EventParticipation.create(user: current_user, event: @event)
    redirect_to event_path(@event)
  end

  def register
    @event = Event.find(params[:id])

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
