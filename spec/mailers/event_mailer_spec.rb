require 'spec_helper'

describe EventMailer do
  let(:default_email) { 'noreply@it61.info' }
  let(:replyto_email) { 'reply@it61.info' }
  let(:user) { FactoryGirl.build_stubbed(:user) }

  describe 'upcoming_event_notification' do
    let(:event) { FactoryGirl.build_stubbed(:event, :published, started_at: 2.days.since) }
    let(:mail) { EventMailer.upcoming_event_notification(user, event) }

    let(:expected_body) { [event.title] }
    let(:expected_subject) do
      days_left = ((event.started_at - DateTime.current)/1.day).round.abs
      "До мероприятия «#{event.title}» осталось #{I18n.t('misc.day', count: days_left)}"
    end

    it_behaves_like 'a well tested mailer'
  end

  describe 'new_events_digest' do
    let(:events) { [FactoryGirl.build_stubbed(:event, :published)] }
    let(:mail) { EventMailer.new_events_digest(user, events) }
    let(:expected_body) { events.map(&:title) }
    let(:expected_subject) { 'Новое мероприятие' }

    it_behaves_like 'a well tested mailer'
  end
end