class StopTime < CUMTD
	def initialize(json)
		@arrival_time = DateTime.parse(json["arrival_time"]).to_time
		@departure_time = DateTime.parse(json["departure_time"]).to_time
	end
	
	
end