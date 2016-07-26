# frozen_string_literal: true
if Rails.env.development? || Rails.env.test?
  require "slim_lint/cli"

  namespace :slim do
    desc "Runs slim linter against views (*.slim)"
    task :lint do
      files = ["app/views"]
      logger = SlimLint::Logger.new(STDOUT)
      SlimLint::CLI.new(logger).run(files)
    end
  end
end
