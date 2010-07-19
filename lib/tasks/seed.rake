require 'mongo'

namespace :db do
  desc "Load seed data into the current environment's database."
  task :seed => :environment do
    db = Mongo::Connection.new.db MONGO_DB_NAME
    Dir.glob(File.join(RAILS_ROOT, 'spec/fixtures', '*.yml')).each do |f|
      coll = db[File.basename(f, '.yml')]  # each fixture is a collection
      refs = File.open(f) {|file| YAML::load(file)} # read a hash of named instances from yaml
      refs && refs.each_value { |val| coll.insert val } # strip off the name, stuff values into a document
    end
  end

  desc "Delete seed data from the current environment's database."
  task :unseed => :environment do
    db = Mongo::Connection.new.db MONGO_DB_NAME
    Dir.glob(File.join(RAILS_ROOT, 'spec/fixtures', '*.yml')).each do |f|
      db[File.basename(f, '.yml')].remove
    end
  end
end
