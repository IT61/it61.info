env :PATH, ENV['PATH']

set :job_template, "bash -l -i -c ':job'"
set :environment, 'production'
set :output, 'log/cron.log'

every 1.months do
  rake 'it61:really_destroy_entities'
end

every :day, at: '9am' do
  rake 'it61:events:reminders:email it61:events:reminders:sms it61:events:new_events_digest'
end