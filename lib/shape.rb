class Shape < CUMTD
	def initialize(json)
		@shape_dist_traveled = json["shape_dist_traveled"]
		@shape_pt_lat = json["shape_pt_lat"]
		@shape_pt_lon = json["shape_pt_lon"]
		@shape_pt_sequence = json["shape_pt_sequence"]
		@shape_stop_id = json["shape_stop_id"] if json["shape_stop_id"]
	end
	
	def shape_dist_traveled
		@shape_dist_traveled
	end

	def shape_pt_lat
		@shape_pt_lat
	end
	
	def shape_pt_lon
		@shape_pt_lon
	end

	def shape_pt_sequence
		@shape_pt_sequence
	end

	def shape_stop_id
		@shape_stop_id
	end
end