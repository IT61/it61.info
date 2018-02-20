namespace :notifications do
  desc "Sends weekly digest about upcoming events"
  task events_digest: :environment do
    upcoming_events = Event.upcoming.where("started_at < ?", 1.week.from_now)
    if upcoming_events.size.zero?
      p "No events to notify about"
    else
      User.notify_by_email.find_each do |user|
        begin
          EventsMailer.new_events_digest(user, upcoming_events).deliver
        rescue => e
          # warn e.message
        end
      end
    end
  end
end
