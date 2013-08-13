require 'httparty'
class CUMTD
	require 'stop'
	require 'stop_point'
	require 'departure'
	require 'route'
	include HTTParty
	base_uri 'developer.cumtd.com/api/v2.2/json'
	def initialize(api_key, stops_file={}, routes_file={}, serialize_path=File.expand_path(File.dirname(__FILE__)))
		@api_key = api_key

		@@all_stops = Array.new
		if stops_file?
			object = nil
			File.open(stops_file,"rb") {|f| @@all_stops = Marshal.load(f)}
		else
			self.get_stops
			serialize_stops(file)
		end

		@@all_routes = Array.new
		if routes_file?
			object = nil
			File.open(routes_file,"rb") {|f| @@all_routes = Marshal.load(f)}
		else
			self.get_routes
		end

		unless serialize_path == :no_serialize
			serialize_stops(File.join(serialize_path, 'stops'))
			serialize_routes(File.join(serialize_path, 'routes'))
		end

	end

	def api_key
		@api_key
	end

	def self.all_stops
		@@all_stops
	end

	def self.all_routes
		@@all_routes
	end

	def serialize_stops(file_location)
		File.open(file_location, "wb") do |file|
			Marshal.dump(@@all_stops,file)
		end
	end

	def serialize_routes(file_location)
		File.open(file_location, "wb") do |file|
			Marshal.dump(@@all_routes,file)
		end
	end

	def get_stops
		response = self.class.get("/GetStops?key=#{@api_key}")
		@@all_stops.clear
		response["stops"].each do |stop|
			@@all_stops << Stop.new(stop)
		end

	end

	def get_routes
		response = self.class.get("/GetRoutes?key=#{@api_key}")
		@@all_routes.clear
		response["routes"].each do |route|
			@@all_routes << Route.new(route)
		end
	end

	def get_stops_by_lat_lon(lat, lon, count=20)
		response = self.class.get("/GetStopsByLatLon?key=#{@api_key}&lat=#{lat}&lon=#{lon}&count=#{count}")
		stops = Array.new
		response["stops"].each do |stop|
			stops << Stop.new(stop)
		end
		return stops
	end

	def print_all_departures(stops)
		stops.each do |stop|
			deps = get_departures_by_stop(stop["stop_id"])
			stop_t = stop 
			print_departures(deps, stop_t)
		end
	end

	def get_routes_by_stop(stop)
		response = self.class.get("/GetRoutesByStop?key=#{@api_key}&stop_id=#{stop.stop_id}")
		routes = Array.new
		response["routes"].each do |route|
			routes << Route.new(route)
		end
		return routes
	end

	def get_stop_by_id(stop_id)
		response = self.class.get("/GetStop?key=#{@api_key}&stop_id=#{stop_id}")
		stop = Stop.new(response["stops"])
		return stop
	end

	def get_departures_by_stop(stop)
		response = self.class.get("/GetDeparturesByStop?key=#{@api_key}&stop_id=#{stop.stop_id}")
		departures = Array.new
		response["departures"].each do |departure|
			departures << Departure.new(departure)
		end
		return departures
	end

	# def print_departures(departures)
	# 	puts stop["stop_name"] unless departures == []
	# 	departures.each do |departure|
	# 		puts departure["headsign"] + " " + departure["expected_mins"].to_s + "mins"
	# 	end
	# end

	# Returns an array of hashes. Each hash contains a "stop" key denoting the stop
	# and the "departures" key contains one departure. These hashes are sorted 
	# based on length of time until they depart, given stops to get departures for.

	def nearest_departures(stops)
		master_deps = Array.new
		stops.each do |stop|
			# master_deps.concat(Hash["stop", stop, "departures", get_departures_by_stop(stop["stop_id"]))
			stops_from_deps = get_departures_by_stop(stop)
			stops_from_deps.each do |stop_dep|
				master_deps << Hash["stop", stop, "departures", stop_dep]
			end
		end
		return master_deps.sort_by! { |stop| stop["departures"].expected_mins  }
	end

	def get_stops_by_search(query, count=10)
		response = self.class.get("/GetStopsBySearch?key=#{@api_key}&query=#{query}&count=#{count}")
		stops = Array.new
		response["stops"].each do |stop|
			stops << Stop.new(stop)
		end
		return stops
	end

	def get_stop_times_by_trip(trip_id)
		response = self.class.get("/GetStopTimesByTrip?key=#{@api_key}&trip_id=#{trip_id}")
		stop_times = Array.new
		response["stop_times"].each do |stop_time|
			stop_times << StopTime.new(stop_time)
		end
		return stop_times
	end

	def get_vehicles
		response = self.class.get("/GetVehicles?key=#{@api_key}")
		vehicles = Array.new
		response["vehicles"].each do |vehicle|
			vehicles << Vehicle.new(vehicle)
		end
		return vehicles
	end

	def get_vehicle_by_id(vehicle_id)
		response = self.class.get("/GetVehicle?key=#{@api_key}&vehicle_id=#{vehicle_id}")
		return Vehicle.new(response["vehicles"].first)
	end

	def get_vehicles_by_route_id(route_id)
		response = self.class.get("/GetVehiclesByRoute?key=#{@api_key}&route_id=#{route_id}")
		vehicles = Array.new
		response["vehicles"].each do |vehicle|
			vehicles << Vehicle.new(vehicle)
		end
		return vehicles
	end

	def get_trip_by_id(trip_id)
		response = self.class.get("/GetTrip?key=#{@api_key}&trip_id=#{trip_id}")
		return Trip.new(response["trips"].first)
	end

end