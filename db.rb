require 'active_record'

ActiveRecord::Base.establish_connection(
  adapter: 'postgresql',
  database: 'planes',
  host: 'localhost',
)

ActiveRecord::Migration.drop_table :planes

class CreatePlanes < ActiveRecord::Migration
  create_table :planes do |t|
    t.string :flight
    t.integer :initial_altitude
    t.integer :time
    t.integer :speed
  end
end

class Plane < ActiveRecord::Base
end
