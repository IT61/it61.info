require 'it61/sms_sender/epochta'

namespace :it61 do

  namespace :event_reminders do
    desc 'Отправить email-напопинания о предстоящем мероприятии пользователям, которые планируют его посетить'
    task email: :environment do
      events = Event.upcomming(2.days.from_now)
      events.each do |event|
        recipients = event.participants.remind_by_email
        recipients.each {|user| EventReminderMailer.send_reminder(user, event).deliver! }
      end
    end

    desc 'Отправить sms-напопинания о предстоящем мероприятии пользователям, которые планируют его посетить'
    task sms: :environment do
      sms_sender = SmsSender::Epochta.new
      Event.upcomming.each do |event|
        recipients = event.participants.remind_by_sms
        recipients.each {|user|
          text = I18n.translate('sms_sender.event_reminder.body',
                                username: user.full_name,
                                event: event.title)
          sms_sender.send!(text, ENV['EPOCHTA_SENDER'], user.normalized_phone)
        }
      end
    end
  end
end