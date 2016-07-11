# frozen_string_literal: true
require "rails_helper"

RSpec.describe Company, type: :model do
  it "has a valid factory" do
    expect(build(:company)).to be_valid
  end

  let(:company) { build(:company) }

  describe "ActiveModel validations" do
    it { expect(company).to validate_presence_of(:name) }
  end
end
