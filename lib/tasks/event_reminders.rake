namespace :it61 do

  desc "Отправить email-напопинания о предстоящем мероприятии пользователям, которые планируют его посетить"
  task send_email_reminders: :environment do
    events = Event.upcomming(2.days.from_now)
    events.each do |event|
      recipients = event.participants.where.not(email: nil)
      recipients.each {|user| EventReminderMailer.send_reminder(user, event).deliver! }
    end
  end
end