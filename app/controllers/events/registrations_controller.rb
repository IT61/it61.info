module Events
  class RegistrationsController < ApplicationController
    load_and_authorize_resource

    def index
      @participants = @event.registrations
    end

    def new
      if current_user.can_fill_entry_form?(@event)
        @entry_form = @event.registration_for(current_user)
      else
        redirect_to @event
      end
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
      attributes = [
        :event_id,
        :reason,
        :profession,
        :suggestions,
        :confidence,
      ]
      params.require(:entry_form).permit(*attributes)
    end
  end
end
