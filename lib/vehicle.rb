require 'json'
class Vehicle < CUMTD
	def initialize(json)
		@vehicle_id = json["vehicle_id"]
		@trip = Trip.new(json["trip"])
		@location = Hash[:lat, json["location"]["lat"], :lon, json["location"]["lon"]]
		@previous_stop_id = json["previous_stop_id"]
		@next_stop_id = json["next_stop_id"]
		@origin_stop_id = json["origin_stop_id"]
		@destination_stop_id = json["destination_stop_id"]
		@last_updated = DateTime.parse(json["last_updated"]).to_time
	end
	
	def vehicle_id
		@vehicle_id
	end

	def trip
		@trip
	end

	def location
		@location
	end

	def previous_stop_id
		@previous_stop_id
	end

	def next_stop_id
		@next_stop_id
	end

	def origin_stop_id
		@origin_stop_id
	end

	def destination_stop_id
		@destination_stop_id
	end

	def last_updated
		@last_updated
	end

	def to_json(*a)
		{
		'vehicle_id' => @vehicle_id,
		'lat' => @location[:lat],
		'lon' => @location[:lon],
		'trip' => @trip
		}.to_json(*a)
	end
	
end