class Stop < CUMTD
	def initialize(json)
		@stop_id = json["stop_id"]
		@stop_name = json["stop_name"]
		@code = json["code"]
		@stop_points = Array.new
		json["stop_points"].each do |stop_point|
			@stop_points << StopPoint.new(stop_point)
		end
	end
	
	def stop_id
		@stop_id
	end
	
	def stop_name
		@stop_name
	end

	def code
		@code
	end

	def stop_points
		@stop_points
	end

	
end