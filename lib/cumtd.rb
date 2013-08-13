require 'httparty'
class CUMTD
	require 'stop'
	require 'stop_point'
	require 'departure'
	require 'route'
	include HTTParty
	base_uri 'developer.cumtd.com/api/v2.2/json'
	def initialize(api_key)
		@api_key = api_key
		@@all_stops = Array.new
		self.get_stops
		@@all_routes = Array.new
		self.get_routes
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

end