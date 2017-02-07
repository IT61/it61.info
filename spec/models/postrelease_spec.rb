require "rails_helper"

RSpec.describe Postrelease, type: :model do
  describe "creating a event with postrelease" do
    context "with valid attributes" do
      it "creates the event" do
        expect {
          create(:event)
        }.to change(Postrelease, :count).by(1)
      end
    end
  end
end
