require 'spec_helper'

describe Event do
  let(:event) { FactoryGirl.create(:event) }
  subject { event }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:organizer) }
  it { should validate_presence_of(:place) }

  context 'publishing' do
    before(:each) do
      subject.publish!
    end

    it 'published' do
      expect(subject.published).to be true
    end

    it 'has filled published_at after publishing' do
      expect(subject.published_at).not_to be_nil
    end

    it 'has clear published_at after cancel publishing' do
      subject.cancel_publication!
      expect(subject.published_at).to be_nil
    end

  end
end
