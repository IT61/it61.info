RSpec.describe Company, type: :model do
  it "has a valid factory" do
    expect(build(:company)).to be_valid
  end

  let(:company) { build(:company) }
  subject { company }

  describe "ActiveModel validations" do
    it { expect(company).to validate_presence_of(:name) }
    it { expect(company).to validate_uniqueness_of(:name) }
  end
end
