def get_status(plane)
  descent_time = 64640/plane[:speed]
    if plane[:status] == "diverted"
      "diverted"
    elsif calculate_distance(plane) < 64640
      "descent"
    elsif (Time.now.to_i - plane[:time]) < (descent_time + 58)
      "final_approach"
    else
      "landed"
    end
end

def divert? (plane)
  front_plane = Plane.where(id: plane[:id]-1)[0]
  if plane[:id] == 1
    false
  elsif calculate_distance(front_plane) > 5200
    false
  else
    true
  end
end

def set_speed (plane)
  if plane[:id] == 1
    128
  else
    front_plane = Plane.where(id: plane[:id]-1)[0]
    time_in_air = (64640 / front_plane[:speed]) - (plane[:time] - front_plane[:time])
    speed = 104
    24.times do
      speed = speed + 1
      distance = time_in_air * speed
      if distance > 64640 - 5200
        break
      end
    end
    return speed
  end
end

def calculate_distance(plane)
  time = Time.now.to_i - plane[:time]
  speed = plane[:speed]
  time * speed
end

def calculate_x(plane)
  d = calculate_distance(plane)
  if d > 64640
    0
  elsif plane[:status] == "diverted"
    nil
  else
    (-2.10E-12*(d*d*d)) + (-4.41E-06*(d*d)) + (0.047*d) + 16000
  end
end

def calculate_y(plane)
  d = calculate_distance(plane)
  if d > 64640
    0
  elsif plane[:status] == "diverted"
    nil
  else
    (2.23E-14*(d*d*d*d)) + (-2.00E-09*(d*d*d)) + (1.022E-04*(d*d)) + (-5*d) + 47000
  end
end

def calculate_altitude(plane)
  d = calculate_distance(plane)
  if d > 64640
    0
  elsif plane[:status] == "diverted"
    nil
  else
    10000-(Time.now.to_i - plane[:time]) * 9200 / (64640 / plane[:speed])
  end
end

def descent_speed(plane)
  64640/plane[:speed]
end

def time_of_landing(plane)
  plane[:time] + descent_speed(plane)
end
