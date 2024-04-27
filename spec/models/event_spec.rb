RSpec.describe Event, type: :model do
  it "has a valid factory" do
    expect(build(:event)).to be_valid
  end

  let!(:event) { create(:event) }
  subject { event }

  describe "ActiveModel validations" do
    it { expect(event).to validate_presence_of(:title) }
    it { expect(event).to validate_presence_of(:description) }
  end

  describe "ActiveRecord associations" do
    it { expect(event).to belong_to(:organizer).class_name("User") }
    it { expect(event).to belong_to(:place).optional }
    it { expect(event).to have_many(:attendees).class_name("User") }
  end

  context "callbacks" do
    let(:event) { create(:event) }
  end
end
