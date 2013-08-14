require 'json'
class Trip < CUMTD
	def initialize(json)
		@trip_id = json["trip_id"]
		@trip_headsign = json["trip_headsign"]
		@route_id = json["route_id"]
		@block_id = json["block_id"]
		@direction = json["direction"]
		@service_id = json["service_id"]
		@shape_id = json["shape_id"]
	end
	
	def to_json(*a)
		{
		'trip_id' => @trip_id,
		'trip_headsign' => @trip_headsign,
		'route_id' => @route_id,
		'block_id' => @block_id,
		'direction' => @direction,
		'service_id' => @service_id,
		'shape_id' => @shape_id
		}.to_json(*a)
	end

	def trip_id
		@trip_id
	end

	def trip_headsign
		@trip_headsign
	end

	def route_id
		@route_id
	end

	def block_id
		@block_id
	end

	def direction
		@direction
	end

	def service_id
		@service_id
	end
	
	def shape_id
		@shape_id
	end

end