require_relative 'delayed_constraint'
require 'libz3'

class TemperatureConverter

	constraint :relationFahrCent, "{ :c * 1.8 == :f - 32.0 }"

	attr_reader :centigrade, :fahrenheit
	
	def initialize
		@centigrade = 130.0
		@fahrenheit = 110.0

		puts('@centigrade: ' + centigrade.to_s)
		puts('@fahrenheit: ' + fahrenheit.to_s)

		always :relationFahrCent, {:c => :@centigrade, :f => :@fahrenheit}, binding

		puts('@centigrade: ' + centigrade.to_s)
		puts('@fahrenheit: ' + fahrenheit.to_s)

		@centigrade = 120.0

		puts('@centigrade: ' + centigrade.to_s)
		puts('@fahrenheit: ' + fahrenheit.to_s)
	end

	def example
		# not working because of Topaz bug, see https://github.com/topazproject/topaz/issues/839
	 	cent = 50.0
		fahr = 100.0
		
		puts('cent: ' + cent.to_s)
		puts('fahr: ' + fahr.to_s)

		once :relationFahrCent, {:c => :cent, :f => :fahr}, binding
	
		puts('cent: ' + cent.to_s)
		puts('fahr: ' + fahr.to_s)
	end
end

t = TemperatureConverter.new
t.example
