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

	def get_stops(lat, lon)
		response = self.class.get("/GetStopsByLatLon?key=#{api_key}&lat=#{lat}&lon=#{lon}")
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

end