# frozen_string_literal: true
require "rails_helper"

RSpec.describe User, type: :model do
  let! (:user) { FactoryGirl.create(:user) }
  subject { user }

  it "has default role (member) after creation" do
    expect(subject.role).to eq(0)
  end

  it "fail validation without phone but sms_reminders" do
    subject.sms_reminders = true
    subject.phone = ""
    subject.save
    expect(subject.errors[:phone].size).to eq(1)
  end

  it "fail validation without email but email_reminders" do
    subject.email_reminders = true
    subject.email = ""
    subject.save
    expect(subject.errors[:email].size).to eq(1)
  end

  it "fail validation without email but subscribed" do
    subject.subscribed = true
    subject.email = ""
    subject.save
    expect(subject.errors[:email].size).to eq(1)
  end
end
