class EventsMailer < ApplicationMailer
  def new_events_digest(user, events)
    @user = user
    @events = events

    mail(to: user.email,
         subject: I18n.t("many", scope: "event_mailer.new_events_digest.subject"))
  end
end
