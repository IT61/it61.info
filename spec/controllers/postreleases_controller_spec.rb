require "rails_helper"

RSpec.describe Events::PostreleasesController, type: :controller do
  context "while logged in as an admin" do
    login_admin

    describe "#public #unpublish" do
      context "with valid attributes" do
        let(:event) { create(:event) }
        it "publishes postrelease" do
          event.postrelease.update(body: "okay")
          put :publish, params: { event_id: event.id, id: event.postrelease.id }
          expect(assigns(:postrelease).published?).to eq(true)
        end
        it "unpublishes postrelease" do
          event.postrelease.update(published: true)
          put :unpublish, params: { event_id: event.id, id: event.postrelease.id }
          expect(assigns(:postrelease).published?).to eq(false)
        end
      end

      context "with invalid attributes" do
        let(:event) { create(:event) }
        it "doesn't publish release if body is empty" do
          event.postrelease.update(body: "")
          put :publish, params: { event_id: event.id, id: event.postrelease.id }
          expect(assigns(:postrelease).published?).to eq(false)
        end
        it "doesn't unpublish release if it's not published" do
          put :unpublish, params: { event_id: event.id, id: event.postrelease.id }
          expect(assigns(:postrelease).published?).to eq(false)
        end
      end
    end

    describe "update postrelease" do
      context "valid att" do
        let(:event) { create(:event) }
        let(:postrelease_att) { attributes_for(:postrelease) }
        it "postrelease edit" do
          put :edit, params: { event_id: event.id, id: event.postrelease.id }
          expect(:postrelease).not_to eq(event.postrelease)
        end
        it "redirect to event" do
          put :update, params: { event_id: event.id, id: event.postrelease.id ,postrelease: postrelease_att }
          expect(response).to redirect_to event
        end
      end
    end
  end
end
