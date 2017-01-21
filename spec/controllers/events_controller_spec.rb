describe EventsController do
  describe "valid route table" do
    it "get /index shows the events list" do
      get :index
      expect(response.status).to eq(200)
      expect(response).to render_template(:index)
    end
  end

  context "while logged in as an user" do
    login_user

    describe "creating a new event" do
      context "with valid attributes" do
        let(:event_attributes) { attributes_for_with_foreign_keys(:event) }

        it "creates the event" do
          expect {
            post :create, params: { event: event_attributes }
          }.to change(Event, :count).by(1)
        end

        it "redirects to the created event" do
          post :create, params: { event: event_attributes }
          expect(response).to redirect_to Event.last
        end

        it "creates the new event with the new place" do
          event_attributes = attributes_for(:event)
          event_attributes["place_attributes"] = attributes_for(:place)

          expect {
            post :create, params: { event: event_attributes }
          }.to change(Event, :count).by(1).
            and change(Place, :count).by(1)
          expect(response).to redirect_to Event.last
        end
      end

      context "with invalid attributes" do
        let(:event_attributes) { attributes_for_with_foreign_keys(:event, title: nil) }
        let(:invalid_place_attributes) { attributes_for(:place, title: nil) }

        it "does not save the new event" do
          expect {
            post :create, params: { event: event_attributes }
          }.to_not change(Event, :count)
        end

        it "re-renders the .new method" do
          post :create, params: { event: event_attributes }
          expect(response).to render_template :new
        end

        it "does now creates the new event with invalid place" do
          event_attributes = attributes_for(:event)
          event_attributes["place_attributes"] = invalid_place_attributes

          expect {
            post :create, params: { event: event_attributes }
          }.to_not change(Event, :count)
        end
      end
    end
  end
end
