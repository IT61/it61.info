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

    describe "invalid route table" do
      it "get /unpublished redirects to new_session_path" do
        get :unpublished

        expect(response.status).to eq(302)
        expect(response).to redirect_to(new_session_path)
      end

      describe "deleting an event" do
        let!(:event) { create(:event) }
        let!(:published_event) { create(:event, :published) }

        it "should not delete unbpublished event and redirect to new_session_path" do
          expect {
            delete :destroy, params: { id: event.id }
          }.to_not change(Event, :count)

          expect(response.status).to eq(302)
          expect(response).to redirect_to(new_session_path)
        end

        it "should not delete published event" do
          expect {
            delete :destroy, params: { id: published_event.id }
          }.to_not change(Event, :count)

          expect(response.status).to eq(302)
          expect(response).to redirect_to(new_session_path)
        end
      end
    end

    describe "creating a new event" do
      context "with valid attributes" do
        let(:event_attributes) { attributes_for(:event) }

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
        let(:event_attributes) { attributes_for(:event, title: nil) }
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

  context "while logged in as an admin" do
    login_admin

    describe "valid route table" do
      let!(:event) { create(:event) }

      it "get /unpubished shows the unpublished events list" do
        get :unpublished

        expect(response.status).to eq(200)
        expect(response).to render_template(:index)
        expect(assigns(:events)).to eq([ event ])
      end
    end

    describe "deleting an event" do
      let!(:event) { create(:event) }

      it "should delete event and redirect to unpublished events path" do
        expect {
          delete :destroy, params: { id: event.id }
        }.to change(Event, :count).by(-1)

        expect(response.status).to eq(302)
        expect(response).to redirect_to(unpublished_events_path)
      end
    end
  end
end
