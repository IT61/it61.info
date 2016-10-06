class Events::ParticipationsController < ApplicationController

  before_action :set_event, only: [:participate, :leave]

  def participate
    @event.new_participant!(current_user) if @event.able_to_participate?
    redirect_to @event
  end

  def leave
    participation = @event.participation_for(current_user)
    EventParticipation.destroy_if_exists(participation)
    redirect_to @event
  end

  def set_event
    @event = Event.find(params[:id])
  end
end
