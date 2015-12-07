require 'sinatra'
require 'active_record'
require './db.rb'
require 'json'

after { ActiveRecord::Base.connection.close }

post '/entry' do
  plane = Plane.create(flight: params[:flight], initial_altitude: params[:altitude], time:Time.now.to_i, speed: set_speed)
  if check_min_distance(plane) < 5200
    puts "Plane is too close, diverting"
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

def check_min_distance(plane)
  min_distance = 5200
  if plane[:id] == 1
    "first plane"
  else
    plane_ahead = Plane.where(id: plane[:id]-1)[0]
    calculate_distance(plane_ahead)
  end
end

def time_in_air(plane)
  Time.now.to_i - plane[:time]
end

def set_speed
  # if Plane.all.count == 0
  #   128
  # else
  #   10000
  # end
  128
end

def calculate_distance(plane)
  time = time_in_air(plane)
  speed = plane[:speed]
  time * speed
end

def calculate_x(plane)
  d = calculate_distance(plane)
  (-2.10E-12*(d*d*d)) + (-4.41E-06*(d*d)) + (0.047*d) + 16000

end
#
def calculate_y(plane)
  d = calculate_distance(plane)
  (2.23E-14*(d*d*d*d)) + (-2.00E-09*(d*d*d)) + (1.022E-04*(d*d)) + (-5*d) + 47000
end
#
def calculate_altitude(plane)
  10000
  a = plane[:initial_altitude]
end
#
def get_status(plane)
  'descent'
end
