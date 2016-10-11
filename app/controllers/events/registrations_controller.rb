module Events
  class RegistrationsController < ApplicationController
    before_action :set_event

    def index
      @participants = @event.registrations
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
      @event = Event.eager_load(:place, :organizer).find(Event.id_from_permalink(params[:id]))
    end
  end
end
