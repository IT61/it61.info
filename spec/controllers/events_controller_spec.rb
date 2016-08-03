require "rails_helper"

describe EventsController do
  describe "valid route table" do
    it "get /index redirects" do
      get :index

      expect(response.status).to eq(302)
    end
  end

  describe "published events" do
    let(:events) { create_list(:event, 5) }

    it "can view" do
      get :upcoming

      expect(response.content_type).to eq "text/html"
      expect(response).to render_template(:index)
      expect(assigns(:events).size).to eq(5)
    end
  end

  describe "creating an event" do
    let(:event_attributes) { attributes_for(:event) }

    it "create an event" do
      post :create, params: { event: :event_attributes }

      expect(response.content_type).to eq "text/html"
      expect(response).to redirect_to Event.first
      expect(Event.count).to eq(1)
    end
  end
end
