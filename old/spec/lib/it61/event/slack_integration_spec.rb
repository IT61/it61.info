require 'spec_helper'

describe 'Event::SlackIntegration' do
  let(:event) { FactoryGirl.create(:event, event_attributes) }
  let(:vcr_options) do
    [
      'slack',
      {
        record: :new_episodes,
        match_requests_on: [:method, :uri, :body]
      }
    ]
  end

  describe '#build_attachment' do
    let(:slack_integration) { Event::SlackIntegration.instance }

    it 'return message json' do
      msg = slack_integration.send(:build_attachment, event)
      expect(msg).to eq(event_notification)
    end
  end

  describe '#notify' do
    it 'return 200 OK response' do
      VCR.use_cassette(*vcr_options) do
        response = Event::SlackIntegration.notify(event)
        expect(response.class).to eq(Net::HTTPOK)
      end
    end
  end

  def event_attributes
    {
      id: 18,
      title: 'Vivamus Metus Arcu, Adipiscing Molestie, Hendrerit At, Vulputate Vitae, Nisl',
      created_at: '2015-11-17T15:45:22.982+03:00',
      updated_at: '2015-11-17T15:45:22.982+03:00',
      description: 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.\n\nVestibulum quam sapien, varius ut, blandit non, interdum in, ante.',
      started_at: '2033-12-27T00:00:00.000+03:00',
      place: '215 Norway Maple Pass'
    }
  end

  def event_notification
    {
      title: 'Vivamus Metus Arcu, Adipiscing Molestie, Hendrerit At, Vulputate Vitae, Nisl',
      title_link: 'http://test.host/events/2033-12-27-vivamus-metus-arcu-adipiscing-molestie-hendrerit-at-vulputate-vitae-nisl-18',
      thumb_url: 'http://test.host/uploads/event/title_image/18/square_500_event_title_image.jpg',
      text: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.\\n\\nVestibulum quam sapien, varius ut, blandit non, interdum in, ante.\n",
      fallback: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.\\n\\nVestibulum quam sapien, varius ut, blandit non, interdum in, ante.\n",
      color: :good,
      fields:
      [
        { title: 'Место проведения', value: '215 Norway Maple Pass', short: true },
        { title: 'Дата начала', value: '27 декабря 2033, 00:00', short: true }
      ]
    }
  end
end
