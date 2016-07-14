# frozen_string_literal: true
class EventsController < ApplicationController

  before_action :authenticate_user!, except: [:index, :show]

  def index

  end

  def show

  end

  def new

  end

  def create

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

end
