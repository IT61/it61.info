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

  end

  def registration
    @event = Event.find(params[:id]).decorate
  end

  def publish

  end

  def unpublish

  end

end
