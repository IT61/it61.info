require 'spec_helper'

describe User do
  let(:user) { FactoryGirl.create(:user) }
  subject { user }

  it 'has default(member) role after creation' do
    expect(subject.role).to eq 'member'
  end
end
