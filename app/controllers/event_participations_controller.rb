class EventParticipationsController < ApplicationController
  respond_to :html
  load_and_authorize_resource param_method: :event_participation_params

  def create
    @event_participation.user = current_user || nil
    @event_participation.save!

    flash[:success] = t(:event_participation_created, title: @event_participation.event.title)
    redirect_to :back
  end

  def destroy
    @event_participation.destroy!

    flash[:success] = t(:event_participation_canceled, title: @event_participation.event.title)
    redirect_to :back
  end

  private

  def event_participation_params
    params.require(:event_participation).permit(:event_id)
  end
end
