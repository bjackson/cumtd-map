class StopPoint < CUMTD
	def initialize(json)
		@code = json["code"]
		@stop_id = json["stop_id"]
		@stop_lat = json["stop_lat"]
		@stop_lon = json["stop_lon"]
		@stop_name = json["stop_name"]
	end
	
	def code
		@code
	end

	def stop_id
		@stop_id
	end

	def stop_lat
		@stop_lat
	end

	def stop_lon
		@stop_lon
	end

	def stop_name
		@stop_name
	end
end

