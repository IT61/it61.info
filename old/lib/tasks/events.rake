require 'it61/sms_sender/epochta'

namespace :it61 do

  namespace :events do
    desc 'Отправить email-уведомления о мероприятиях опуликованных в течении вчерашнего дня'
    task new_events_digest: :environment do
      events = Event.published.upcoming.published_in(1.day.ago).not_notified_about
      Rails.logger.info "No new events" and exit(0) if events.blank?

      Rails.logger.info "New events found: #{events.count}"
      begin
        recipients = User.with_email.subscribed
        recipients.each do |user|
          Rails.logger.info "Sending notification abount new events to user (id = [#{user.id}], email = [#{user.email}])"
          EventMailer.new_events_digest(user, events).deliver!
        end
        Rails.logger.info "Notification for event [#{event.id}] is sended. Users notified: #{recipients.count}]"
      rescue => e
        Rollbar.error(e, 'Events notification digest creating/sending error')
      ensure
        events.update_all(subscribers_notification_send: true)
      end
    end

    namespace :reminders do
      desc 'Отправить email-напопинания о предстоящем мероприятии пользователям, которые планируют его посетить'
      task email: :environment do
        events = Event.published.upcoming.started_in(2.days.from_now)
        events.each do |event|
          recipients = event.participants.notify_by_email
          recipients.each {|user| EventMailer.upcoming_event_reminder(user, event).deliver! }
        end
      end

      desc 'Отправить sms-напопинания о предстоящем мероприятии пользователям, которые планируют его посетить'
      task sms: :environment do
        sms_sender = SmsSender::Epochta.new
        Event.published.upcoming.today.each do |event|
          recipients = event.participants.notify_by_sms
          recipients.each {|user|
            text = I18n.translate('sms_sender.upcoming_event_reminder.body',
                                  username: user.full_name,
                                  event: event.title)
            sms_sender.send!(text, ENV['EPOCHTA_SENDER'], user.normalized_phone)
          }
        end
      end
    end
  end
end
