require 'spec_helper'

describe EventMailer do
  let(:default_email) { 'noreply@it61.info' }
  let(:replyto_email) { 'reply@it61.info' }
  let(:user) { FactoryGirl.build_stubbed(:user) }

  describe 'upcoming_event_reminder' do
    let(:event) { FactoryGirl.build_stubbed(:event, :published, started_at: 2.days.ago) }
    let(:mail) { EventMailer.upcoming_event_reminder(user, event) }

    let(:expected_body) { [event.title] }
    let(:expected_subject) do
      days_left = ((Time.current - event.started_at)/1.day).round
      "До мероприятия «#{event.title}» осталось #{I18n.t('misc.day', count: days_left)}"
    end

    it_behaves_like 'a well tested mailer'
  end

  describe 'new_events_digest' do
    let(:events) { [FactoryGirl.build_stubbed(:event, :published)] }
    let(:mail) { EventMailer.new_events_digest(user, events) }
    let(:expected_body) { events.map(&:title) }
    let(:expected_subject) { events.many? ? 'Новые мероприятия' : 'Новое мероприятие' }

    it_behaves_like 'a well tested mailer'
  end
end