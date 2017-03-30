RSpec.describe Events::AttendeesController, type: :controller do
  context "while not logged in as an user" do
    let(:event) { create(:event, :published) }

    describe "attending the published event" do
      let(:event) { create(:event, :published) }

      it "should redirect to sign_in page" do
        post :create, params: { event_id: event.id }
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(new_session_path)
      end
    end
  end

  context "while logged in as an user" do
    let(:event) { create(:event, :published) }
    login_user

    describe "POST #create" do
      it "returns http found and redirects to the event" do
        expect {
          post :create, params: { event_id: event.id }
        }.to change(event.attendees, :count).by(1)
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(event)
      end
    end

    describe "DELETE #destroy" do
      let(:events_attendee) { create(:events_attendee) }

      it "returns http found and redirects to the event" do
        delete :destroy, params: { event_id: event.id, id: events_attendee.id }
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(event)
      end
    end
  end
end
