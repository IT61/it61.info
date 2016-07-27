require "rails_helper"

RSpec.describe User, type: :model do
  it "has a valid factory" do
    expect(build(:user)).to be_valid
  end

  let! (:user) { create(:user) }
  subject { user }

  describe "ActiveModel validations" do
    it { expect(user).to validate_presence_of(:role) }

    before { subject.sms_reminders = true }
    it { expect(user).to validate_presence_of(:phone) }

    before { subject.email_reminders = true }
    it { expect(user).to validate_presence_of(:email) }

    it { expect(user).to validate_uniqueness_of(:email).case_insensitive }

    it { expect(user.role).to eq("member") }
  end

  context "callbacks" do
    let(:user) { create(:user) }

    it { expect(user).to callback(:nullify_empty_email).before(:save) }
    it { expect(user).to callback(:assign_defaults).before(:create) }
  end

  describe "public instance methods" do
    context "responds to its methods" do
      it { expect(user).to respond_to(:full_name) }
      it { expect(user).to respond_to(:pic) }
      it { expect(user).to respond_to(:remember_me) }
      it { expect(user).to respond_to(:event_participations) }
      it { expect(user).to respond_to(:subscribe!) }
      it { expect(user).to respond_to(:fresh?) }
      it { expect(user).to respond_to(:has_events?) }
    end

    context "executes methods correctly" do
      context "full_name" do
        it "returns space-separated first name and last name" do
          expected_value = user.first_name + " " + user.last_name
          expect(user.full_name).to eq(expected_value)
        end

        context "full_name partial" do
          let!(:name_expected_value) { user.name }

          before { subject.first_name = nil }
          it "return name if first name is empty" do
            expect(user.full_name).to eq(name_expected_value)
          end

          before { subject.last_name = nil }
          it "return name if last name is empty" do
            expect(user.full_name).to eq(name_expected_value)
          end

          it "return only name if first name and last name are empty" do
            expect(user.full_name).to eq(name_expected_value)
          end
        end
      end
    end
  end

  describe "public class methods" do
    context "responds to its methods" do
      it { expect(User).to respond_to(:link_for) }
    end
  end
end
