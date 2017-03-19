RSpec.describe Events::AttendeesController, type: :controller do
  context "while not logged in as an user" do
    let(:event) { create(:event, :published) }

    describe "GET #index" do
      it "returns http success" do
        get :index, params: { event_id: event.id }
        expect(response).to have_http_status(:success)
      end
    end
  end

  context "while logged in as an user" do
    let(:event) { create(:event, :published) }
    login_user

    describe "POST #create" do
      it "returns http found and redirect to the event" do
        post :create, params: { event_id: event.id }
        expect(response).to have_http_status(:found)
        expect(response).to redirect_to(event)
      end
    end
  end
end
