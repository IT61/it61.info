class EventsController < ApplicationController
  respond_to :html
  respond_to :ics, only: :show
  respond_to :rss, only: :index
  responders :flash

  load_resource param_method: :event_params
  before_filter :set_organizer, only: :create
  authorize_resource

  has_scope :page, default: 1, if: ->(w){ w.request.format.html? }
  has_scope :per, default: 10, if: ->(w){ w.request.format.html? }
  has_scope :ordered_desc, type: :boolean, allow_blank: true, default: true

  def index
    @events = apply_scopes(@events)
    first_upcoming_event = @events.upcoming.last
    last_past_event = @events.past.first

    if first_upcoming_event.present? && last_past_event.present?
      @render_separator_after_id = first_upcoming_event.id
    end

    @events = @events.decorate
    respond_with @events do |f|
      f.html { render layout: !request.xhr? }
    end
  end

  def show
    # Редирект на базовый актуальный url в том случае, если передан устаревший.
    if params[:id] != @event.to_param
      redirect_to event_path(@event), status: :moved_permanently
      return
    end

    @event = @event.decorate
    respond_with @event do |format|
      format.ics do
        ics_generator = Event::IcsGenerator.new(@event)
        send_data ics_generator.ics_content, filename: ics_generator.file_name, type: ics_generator.conten_type
      end
    end
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

  def destroy
    @event.destroy
    flash[:success] = t('.success_message', title: @event.title)
    respond_with @event, location: events_path
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
