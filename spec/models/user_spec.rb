require 'spec_helper'

describe User do
  let(:user) { FactoryGirl.create(:user) }
  subject { user }

  it 'has default(member) role after creation' do
    expect(subject.role).to eq 'member'
  end

  it 'subscribed' do
    expect(subject.subscribed).to be(true)
  end

  it 'pass validation with sms_reminders and phone' do
    subject.sms_reminders = true
    subject.phone = '+71234567890'
    subject.save
    expect(subject).to have(0).errors_on(:phone)
  end

  it 'fail validation with sms_reminders and no phone' do
    subject.sms_reminders = true
    subject.phone = ''
    subject.save
    expect(subject).to have(1).errors_on(:phone)
  end
end
