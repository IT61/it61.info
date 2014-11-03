env :PATH, ENV['PATH']

set :job_template, "bash -l -i -c ':job'"
set :environment, 'production'
set :output, 'log/cron.log'

every 1.months do
  rake 'it61:really_destroy_entities'
end
