require 'sinatra'
require 'active_record'
require './db.rb'
require './calculations.rb'
require 'json'
require 'date'

after { ActiveRecord::Base.connection.close }

post '/entry' do
  plane = Plane.create(flight: params[:flight], initial_altitude: params[:altitude], time:Time.now.to_i, speed: 128)
  if divert? (plane)
    plane.update(status: "diverted")
  else
    plane.update(speed: set_speed(plane))
  end

end

get '/tracking_info' do
  planes_info = []
  Plane.all.each do |plane|
    info = {}
    info[:flight] = plane[:flight]
    info[:x] = calculate_x(plane)
    info[:y] = calculate_y(plane)
    info[:altitude] = calculate_altitude(plane)
    info[:status] = get_status(plane)
    planes_info.push(info)
  end
  planes_info.to_json
end
