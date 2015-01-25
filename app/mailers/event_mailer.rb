class EventMailer < ActionMailer::Base

  def upcoming_event_notification(user, event)
    @user = user
    @event = event

    subj = I18n.t('event_mailer.upcoming_event_notification.subject',
                  event: event.title,
                  days_left: I18n.translate('misc.day', count: 2))
    mail(to: user.email, subject: subj)
  end

  def new_events_digest(user, events)
    @user = user
    @events = events

    subj_key = events.many? ? 'many' : 'single'
    mail(to: user.email,
         subject: I18n.t(subj_key, scope: 'event_mailer.new_events_digest.subject'))
  end

end
