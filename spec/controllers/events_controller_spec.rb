require 'rails_helper'

RSpec.describe EventsController, type: :controller do

  before :each do
    @title = 'New title'
    @started_at = Time.now
    @locations = [
      {
        title: 'Классное место',
        address: 'Пушкинская',
        latitude: 47.2268489,
        longitude: 39.7149856,
        extra_info: 'Этаж 25'
      },
      {
        title: 'Другое место',
        address: 'Садовая',
        latitude: 48.0,
        longitude: 40
      }
    ]
    @data = {
      title: @title,
      title_image: 'img.png',
      description: 'whatever',
      started_at: @started_at,
      locations: @locations
    }
  end

  describe 'POST #create' do
    login_user

    it 'creates new event' do
      post :create, event: @data
      event = assigns(:event)
      expect(event.title).to eq(@title)
      expect(event.started_at).to eq(@started_at.to_s)
    end

    it 'populates event with locations' do
      post :create, event: @data
      event = assigns(:event)
      expect(event.locations.count).to eq(2)
    end

    it 'links created event to organizer' do
      post :create, event: @data
      event = assigns(:event)
      expect(event.organizer).to eq(subject.current_user)
    end
  end
end
