require 'spec_helper'

describe Event do
  let(:event) { FactoryGirl.create(:event) }
  subject { event }

  it { expect(subject).to validate_presence_of(:title) }
  it { expect(subject).to validate_presence_of(:organizer) }
  it { expect(subject).to validate_presence_of(:place) }

  context 'publishing' do
    before do
      allow_any_instance_of(Event).to receive(:send_slack_notification).and_return(true)
    end
    before(:each) { subject.publish! }

    describe '#publish!' do
      context 'unpublished event' do

        it 'published' do
          expect(subject.published).to be(true)
        end

        it 'has filled published_at' do
          expect(subject.published_at).not_to be_nil
        end

        it 'has invoke #send_slack_notification' do
          subject.cancel_publication!
          expect(subject).to receive(:send_slack_notification)
          subject.publish!
        end
      end

      context 'published event' do
        let(:published_at) { DateTime.current }
        let(:event) { FactoryGirl.create(:event, :published, published_at: published_at) }

        it 'stay published' do
          expect(subject.published).to be(true)
        end

        it 'has old published_at' do
          expect(event.published_at).to eq(published_at)
        end

        it 'has not invoke #send_slack_notification' do
          expect(subject).not_to receive(:send_slack_notification)
          subject.publish!
        end
      end
    end

    describe '#cancel_publication!' do
      before(:each) { subject.cancel_publication! }

      it 'not published' do
        expect(subject.published).to be(false)
      end

      it 'has clear published_at after cancel publishing' do
        expect(subject.published_at).to be_nil
      end
    end
  end
end
