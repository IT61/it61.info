# Preview all emails at http://localhost:3000/rails/mailers/events
class EventsPreview < ActionMailer::Preview
  def new_events_digest
    EventsMailer.new_events_digest(User.last, Event.upcoming.where("started_at < ?", 1.week.from_now))
  end
end
