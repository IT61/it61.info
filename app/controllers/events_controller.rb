class EventsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  def index
  
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
      e.started_at = ep[:started_at]
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
    params.require(:participant_entry_form).permit('reason', 'profession', 'suggestions', 'confidence')
  end

  def places
    @places = Place.where("title like :title and address like :address", title: "%#{params[:title]}%", address: "%#{params[:address]}%").limit(5)
    render json: @places.map { |p| to_yand_obj p }
  end

  private

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
    params.require(:event).permit :title, :description, :title_image, :started_at,
      :extra_info, :title, :address, :latitude, :longitude, :place_title
  end

  def new_location_with_place
    place = Place.where(title: event_params[:place_title], address: event_params[:address],
      latitude: event_params[:latitude], longitude: event_params[:longitude]).first_or_create

    Location.where(extra_info: event_params[:extra_info],
      place: place).first_or_create
  end
end
