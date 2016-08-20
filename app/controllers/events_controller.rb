class EventsController < ApplicationController
  respond_to :html
  respond_to :json
  respond_to :ics, only: :show
  respond_to :rss, only: :index

  before_action :authenticate_user!, except: [:index, :show, :upcoming, :past]
  before_action :set_event, only: [:show,
                                   :participate,
                                   :register,
                                   :revoke_participation,
                                   :add_to_google_calendar,
                                   :download_ics_file]

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
    @event.build_place
  end

  # rubocop:disable Metrics/AbcSize
  def create
    event_params[:title_image].original_filename << ".png"
    @event = Event.new(event_params)
    @event.organizer = current_user
    p = place_params
    @event.place ||= Place.where(title: p[:title], address: p[:address],
       latitude: p[:latitude], longitude: p[:longitude]).first_or_create

    if @event.save
      flash[:success] = t("flashes.event_successfully_created")
      render json: {success: event_path(@event)}
    else
      render json: {success: false, errors: @event.errors.messages}
    end
  end

  def edit
  end

  def destroy
  end

  def participate
    if @event.opened? || @event.past?
      @event.register_user!(current_user)
    end
    redirect_to event_path(@event)
  end

  def register
    # there is no business if event have open registration
    # todo: refactor complex logic with unless into its own method
    unless @event.closed? || @event.user_participated?(current_user)
      return redirect_to @event
    end

    # if user already have some entry form for this event...
    @entry_form = @event.entry_form_for(current_user)
    save_entry_form(@entry_form) if request.post?
  end

  def revoke_participation
    participation = @event.participation_for(current_user)
    EventParticipation.destroy(participation) unless participation.blank?
    redirect_to event_path(@event)
  end

  def publish
    @event = Event.find(params[:id])
    @event.publish!
  end

  def unpublish
  end

  def add_to_google_calendar
    refresh_token = current_user.google_refresh_token
    @result = GoogleService.add_event_to_calendar(refresh_token, @event)

    if @result && @result.status == 200
      redirect_to event_path(@event), notice: t("flashes.event_successfully_added_to_google_calendar")
    else
      redirect_to event_path(@event), error: t("flashes.event_failure_to_add_to_google_calendar")
    end
  end

  def download_ics_file
    calendar = IcsService.to_ics_calendar(@event, event_url(@event))
    options = IcsService.file_options_for(@event)
    send_data calendar, options
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def save_entry_form(form)
    # save entry form
    form.event = @event
    form.user = current_user
    form.update(entry_form_params)
    form.save

    # mark user as participant
    @event.register_user!(current_user)
    redirect_to @event
  end

  def entry_form_params
    params.require(:entry_form).permit("reason", "profession", "suggestions", "confidence")
  end

  def show_events(scope)
    @events = Event.send(scope).published.paginate(page: params[:page], per_page: 6)
    @scope = scope

    view = request.xhr? ? "events/_cards" : "events/index"
    respond_with @events do |f|
      f.html { render view, layout: !request.xhr? }
    end
  end

  def redirect_to_relevant_scope
    path = Event.published.upcoming.count.positive? ? upcoming_events_path : past_events_path
    redirect_to path
  end

  def show_correct_scope
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
    ]
    params.require(:event).permit(*permitted_attrs)
  end

  def place_params
    place_attrs = [:title, :address, :latitude, :longitude]
    params.require(:place).permit(*place_attrs)
  end
end
