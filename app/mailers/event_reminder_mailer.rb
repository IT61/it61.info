class EventReminderMailer < ActionMailer::Base

  def send_reminder(user, event)
    @user = user
    @event = event

    subj = I18n.t('event_reminder_mailer.send_reminder.subject',
                  event: event.title,
                  days_left: I18n.translate('misc.day', count: 2))
    mail(to: user.email, subject: subj)
  end
end
