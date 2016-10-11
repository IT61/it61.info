namespace :db do
  require File.dirname(__FILE__) + "/importer/importer"

  desc "Transition data from old database, usage: rake db:transition['old_db_name']"
  task :transition, [:old_database] => :environment do |_t, args|
    args.with_defaults(old_database: "it61_old")

    old_db = args.old_database.to_sym
    new_db = Rails.env.to_sym

    importer = Importer.new(old_db, new_db)
    importer.exec
  end
end
