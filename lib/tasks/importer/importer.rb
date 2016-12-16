Dir[File.join(File.dirname(__FILE__), "*importer.rb")].each { |file| require file }

class Importer
  include UsersImporter
  include EventsImporter
  include EventParticipationsImporter
  include SocialAccountsImporter

  SEQUENCE_MAP = [
    { table: "users", reset: true },
    { table: "social_accounts", reset: true },
    { table: "events", reset: true },
    { table: "event_participations", reset: true },
  ].freeze

  def initialize(old_db, new_db)
    puts "Importing data from #{old_db} to #{new_db}"

    @old_db = old_db
    @new_db = new_db
  end

  def exec
    SEQUENCE_MAP.each do |action|
      method("import_#{action[:table]}").call
      reset_sequence(action[:table]) if action[:reset]
    end
  end

  def use_new_db
    ActiveRecord::Base.establish_connection(@new_db)
  end

  def use_old_db
    ActiveRecord::Base.establish_connection({
      adapter: :postgresql, database: @old_db
    })
  end

  def reset_sequence(table)
    puts "Resetting the sequence for #{table}"
    ActiveRecord::Base.connection.execute("SELECT setval('#{table}_id_seq', COALESCE((SELECT MAX(id)+1 FROM #{table}), 1), false);")
  end
end

class Row
  attr_accessor :fields

  def initialize(fields, values)
    @fields = fields
    @values = values
  end

  def get(field)
    @values[@fields.index(field)]
  end
end

class PG::Result
  def get_row(index)
    Row.new fields, values[index].to_a
  end
end
