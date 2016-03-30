require 'spec_helper'

describe EventsController do
  context 'POST create' do
    specify 'unlogged user cannot create event' do
      event_attrs = FactoryGirl.attributes_for(:event)
      expect { post :create, event: event_attrs }.to_not change(Event, :count)
    end

    specify 'member can create event' do
      @user = FactoryGirl.create :user
      login_user

      event_attrs = FactoryGirl.attributes_for(:event)
      request = post :create, event: event_attrs

      created_event = Event.last
      expect(request).to redirect_to event_path(created_event)
    end

    specify "event'll be unpublished if member create it" do
      @user = FactoryGirl.create :admin
      login_user

      event_attrs = FactoryGirl.attributes_for(:event)
      post :create, event: event_attrs

      created_event = Event.last
      expect(created_event).to_not be_published
    end

    specify 'admin can create event' do
      @user = FactoryGirl.create :admin
      login_user

      event_attrs = FactoryGirl.attributes_for(:event)
      request = post :create, event: event_attrs

      created_event = Event.last
      expect(request).to redirect_to event_path(created_event)
    end

    it 'assigns organizer to event' do
      @user = FactoryGirl.create :admin
      login_user

      event_attrs = FactoryGirl.attributes_for(:event)
      post :create, event: event_attrs

      created_event = Event.last
      expect(created_event.organizer).to eq @user
    end
  end
end
