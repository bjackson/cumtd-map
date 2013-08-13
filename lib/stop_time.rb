class StopTime < CUMTD
	require 'stop_point'
	def initialize(json)
		@arrival_time = DateTime.parse(json["arrival_time"]).to_time
		@departure_time = DateTime.parse(json["departure_time"]).to_time
		@stop_sequence = json["stop_sequence"]
		@stop_point = StopPoint.new(json["stop_point"])
	end
	
	def arrival_time
		@arrival_time
	end

	def departure_time
		@departure_time
	end

	def stop_sequence
		@stop_sequence
	end

	def stop_point
		@stop_point
	end

end