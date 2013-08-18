require "sinatra"
require 'cumtd'
require 'json'
require 'rufus-scheduler'
require 'yaml'
require 'colorize'
require 'builder'




c = CUMTD.new(ENV["CUMTD_API_KEY"], nil, nil, :no_serialize)
vehicles = c.get_vehicles
refreshed_at = Time.now.to_i
refresh_at = Time.now.to_i + 62
reroutes = c.get_reroutes
vehicle_refresher = Rufus::Scheduler.new
reroute_refresher = Rufus::Scheduler.new


# ARGV.each do |arg|
# 	if arg == "load"
# 		File.open(File.expand_path(File.join(File.dirname(__FILE__), "vehicles.yaml")),"rb") {|f| vehicles = YAML.load(f)}
# 	else
# 		vehicles = c.get_vehicles
# 		puts "Refreshed vehicles at: " + Time.now.strftime("%l:%M:%S").blue
# 		c.serialize_vehicles(vehicles, File.expand_path(File.join(File.dirname(__FILE__), "vehicles.yaml")))
# 	end
# end

#File.open(File.expand_path(File.join(File.dirname(__FILE__), "vehicles copy.yaml")),"rb") {|f| vehicles = YAML.load(f)}

vehicle_refresher.every '60s', :first_at => Time.now do
	vehicles = c.get_vehicles
	# File.open(File.expand_path(File.join(File.dirname(__FILE__), "vehicles copy.yaml")),"rb") {|f| vehicles = YAML.load(f)}
	puts "Refreshed vehicles at: " + Time.now.strftime("%l:%M:%S").blue
	refreshed_at = Time.now.to_i
	refresh_at = Time.now.to_i + 62
	#c.serialize_vehicles(vehicles, File.expand_path(File.join(File.dirname(__FILE__), "vehicles.yaml")))
end

reroute_refresher.every '10m' do
	reroutes = c.get_reroutes
end


get '/' do
	@vehicles = vehicles
	@refreshed_at = refreshed_at
	@refresh_at = refresh_at
	@reroutes = reroutes
	erb :index
end

get '/update_locs.json' do
	content_type :json
	{:vehicles => vehicles,
	:refreshed_at => refreshed_at,
	:refresh_at => refresh_at,
	:reroutes => reroutes}.to_json
end

get '/update_reroutes.json' do
	content_type :json
	@reroutes = reroutes
end

# content: '<span class="routeIcon" style="background-color: #' + vehicle.route.route_text_color + '"' +  '>' + vehicle.trip.route_id + ' - ' + vehicle.trip.direction + '</span>'