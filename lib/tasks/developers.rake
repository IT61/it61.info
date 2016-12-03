namespace :db do
  require File.dirname(__FILE__) + "/importer/importer"

  desc "Assigns developers to Developer group, usage: rake db:seed:users['data_file']"
  task :users, [:data_file] => :environment do |_t, args|
    if args.data_file.blank? || !File.exist?(args.data_file)
      raise "Data file can't be empty"
    end

    options = JSON.parse(File.read(args.data_file))

    if options["group"].empty?
      raise "Target group is empty"
    end

    target_group = Group.find_by(name: options["group"])
    if target_group.empty?
      raise "Can't find the target group #{target_group}"
    end

    options["emails"].each do |email|
      u = User.find_by(email: email)
      unless u.empty?
        u.groups << target_group
        u.save!
      else
        puts "Unable to find user: #{email}"
      end
    end
  end
end
