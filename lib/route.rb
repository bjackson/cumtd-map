class Route < CUMTD
	def initialize(json)
		@route_color = json["route_color"]
		@route_id = json["route_id"]
		@route_long_name = json["route_long_name"]
		@route_short_name = json["route_short_name"]
		@route_text_color = json["route_text_color"]
	end
	
	def route_color
		@route_color
	end

	def route_id
		@route_id
	end

	def route_long_name
		@route_long_name
	end

	def route_short_name
		@route_short_name
	end

	def route_text_color
		@route_text_color
	end
end