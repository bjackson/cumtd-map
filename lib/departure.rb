require 'trip'
require 'route'
class Departure < CUMTD
	def initialize(json)
		@stop_id = json["stop_id"]
		@headsign = json["headsign"]
		@trip = Trip.new(json["trip"])
		@vehicle_id = json["vehicle_id"]
		@origin = CUMTD.all_stops.select { |stop| stop.stop_points.each == \
			json["origin"]["stop_id"] }
		@destination = CUMTD.all_stops.select { |stop| stop.stop_points.each == \
			json["destination"]["stop_id"] }
		@is_monitored = json["is_monitored"]
		@is_scheduled = json["is_scheduled"]
		@scheduled = DateTime.parse(json["scheduled"]).to_time
		@expected = DateTime.parse(json["expected"]).to_time
		@expected_mins = json["expected_mins"]
		@location = Hash[:lat, json["location"]["lat"], :lon, json["location"]["lon"]]
	end
	
	def stop_id
		@stop_id
	end

	def headsign
		@headsign
	end

	def trip
		@trip
	end

	def vehicle_id
		@vehicle_id
	end

	def origin
		@origin
	end

	def destination
		@destination
	end

	def is_monitored
		@is_monitored
	end

	def is_scheduled
		@is_scheduled
	end

	def scheduled
		@scheduled
	end

	def expected
		@expected
	end

	def expected_mins
		@expected_mins
	end

	def location
		@location
	end
end