class RegistrationsController < ApplicationController
  before_action :set_event, except: [:visits, :mark_visit]

  def index
    @participants = @event.registrations
  end

  def visits
    @event = Event.find_by_secret_word(params[:hash])
    @participants
  end

  def mark_visit
    @event = Event.find_by_secret_word(params[:hash])
    p = @event.participation_for(User.find(params[:user_id]))
    p.visited = params[:visited]
    p.save
  end

  def new
    return redirect_to @event unless current_user.can_fill_entry_form?(@event)

    @entry_form = @event.registration_for(current_user)
  end

  def create
    return redirect_to @event unless current_user.can_fill_entry_form?(@event)

    entry_form = @event.registration_for(current_user)
    save_registration(entry_form)

    @event.new_participant!(current_user)
    redirect_to @event
  end

  private

  def save_registration(form)
    form.event = @event
    form.user = current_user
    form.update(registration_params)
    form.save
  end

  def registration_params
    params.require(:entry_form).permit("reason", "profession", "suggestions", "confidence")
  end

  def set_event
    @event = Event.find(params[:id])
  end
end
