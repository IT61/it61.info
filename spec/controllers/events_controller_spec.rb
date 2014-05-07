require 'spec_helper'

describe EventsController do
  context 'POST create' do
    specify 'unlogged user cannot create event' do
      event_attrs = FactoryGirl.attributes_for(:event)
      expect { post :create, event: event_attrs }.to raise_error(CanCan::AccessDenied)
    end

    specify 'member cannot create event' do
      @user = FactoryGirl.create :user
      login_user

      event_attrs = FactoryGirl.attributes_for(:event)
      expect { post :create, event: event_attrs }.to raise_error(CanCan::AccessDenied)
    end

    specify 'admin can create event' do
      @user = FactoryGirl.create :admin
      login_user

      event_attrs = FactoryGirl.attributes_for(:event)
      post :create, event: event_attrs

      created_event = Event.first
      should redirect_to event_path(created_event)
    end

    it 'assigns organizer to event' do
      @user = FactoryGirl.create :admin
      login_user

      event_attrs = FactoryGirl.attributes_for(:event)
      post :create, event: event_attrs

      created_event = Event.first
      expect(created_event.organizer).to eq @user
    end
  end
end
