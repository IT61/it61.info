require 'spec_helper'

describe EventsController, type: :controller do
  context 'POST create' do
    it 'unlogged user cannot create event' do
      event_attrs = FactoryGirl.attributes_for(:event)
      expect { post :create, event: event_attrs }.to raise_error(CanCan::AccessDenied)
    end

    it 'member can create event' do
      @user = FactoryGirl.create :user
      login_user

      event_attrs = FactoryGirl.attributes_for(:event)
      request = post :create, event: event_attrs

      created_event = Event.last
      expect(request).to redirect_to event_path(created_event)
    end

    it "event'll be unpublished if member create it" do
      @user = FactoryGirl.create :admin
      login_user

      event_attrs = FactoryGirl.attributes_for(:event)
      post :create, event: event_attrs

      created_event = Event.last
      expect(created_event).to_not be_published
    end

    it 'admin can create event' do
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
