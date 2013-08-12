require 'httparty'
class CUMTD
	include HTTParty
	base_uri 'developer.cumtd.com/api/v2.2/json'
	def initialize(api_key)
		@api_key = api_key
	end

	def api_key
		@api_key
	end

	def current_stops
		@current_stops
	end

	def get_stops(lat, lon, count=20)
		response = self.class.get("/GetStopsByLatLon?key=#{api_key}&lat=#{lat}&lon=#{lon}&count=#{count}")
		current_stops = response["stops"]
		return stops = response["stops"]
	end

	def print_all_departures(stops)
		stops.each do |stop|
			deps = get_departures_by_stop(stop["stop_id"])
			stop_t = stop 
			print_departures(deps, stop_t)
		end
	end

	def get_routes_by_stop(stop_id)
		response = self.class.get("/GetRoutesByStop?key=#{api_key}&stop_id=#{stop_id}")
		return response.parsed_response["routes"]
	end

	def get_stop_by_id(stop_id)
		response = self.class.get("/GetStop?key=#{api_key}&stop_id=#{stop_id}")
		return response.parsed_response["stops"].first["stop_name"]
	end

	def get_departures_by_stop(stop_id)
		response = self.class.get("/GetDeparturesByStop?key=#{api_key}&stop_id=#{stop_id}")
		return departures = response.parsed_response["departures"]
	end

	def print_departures(departures, stop)
		puts stop["stop_name"] unless departures == []
		departures.each do |departure|
			puts departure["headsign"] + " " + departure["expected_mins"].to_s + "mins"
		end
	end

	# Returns an array of hashes. Each hash contains a "stop" key denoting the stop
	# and the "departures" key contains one departure. These hashes are sorted 
	# based on length of time until they depart, given stops to get departures for.

	def nearest_departures(stops)
		master_deps = Array.new
		stops.each do |stop|
			# master_deps.concat(Hash["stop", stop, "departures", get_departures_by_stop(stop["stop_id"]))
			stops_from_deps = get_departures_by_stop(stop["stop_id"])
			stops_from_deps.each do |stop_dep|
				master_deps << Hash["stop", stop, "departures", stop_dep]
			end
		end
		return master_deps.sort_by! { |stop| stop["departures"]["expected_mins"]  }
	end

end