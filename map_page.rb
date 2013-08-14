require "sinatra"
require 'cumtd'
require 'json'
require 'rufus-scheduler'
require 'yaml'
require 'colorize'

c = CUMTD.new(ENV["CUMTD_API_KEY"])
vehicles = Array.new

vehicle_refresher = Rufus::Scheduler.new

ARGV.each do |arg|
	if arg == "load"
		File.open(File.expand_path(File.join(File.dirname(__FILE__), "vehicles.yaml")),"rb") {|f| vehicles = YAML.load(f)}
	else
		vehicles = c.get_vehicles
		puts "Refreshed vehicles at: " + Time.now.strftime("%l:%M:%S").blue
		c.serialize_vehicles(vehicles, File.expand_path(File.join(File.dirname(__FILE__), "vehicles.yaml")))
	end
end


vehicle_refresher.every '60s', :first_at => Time.now do
	vehicles = c.get_vehicles
	puts "Refreshed vehicles at: " + Time.now.strftime("%l:%M:%S").blue
	c.serialize_vehicles(vehicles, File.expand_path(File.join(File.dirname(__FILE__), "vehicles.yaml")))
end


get '/' do
	@vehicles = vehicles
	erb :index
end