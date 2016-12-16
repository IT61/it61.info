module Events
  class ParticipationsController < ApplicationController
    load_and_authorize_resource

    def participate
      @event.new_participant!(current_user) if @event.able_to_participate?
      redirect_to @event
    end

    def leave
      participation = @event.participation_for(current_user)
      EventParticipation.destroy_if_exists(participation)
      redirect_to @event
    end

    private

    def event_params
      params.require(:event).permit(:id)
    end
  end
end
