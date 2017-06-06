require_relative 'delayed_constraint'

class TemperatureConverter

	CentFahrRel = DelayedConstraint.new("always {c * 1.8 == f - 32.0 }")

	def initialize

		@centigrade = 100.0
		@fahrenheit = 100.0

		CentFahrRel.bind({:c => '@centigrade', :f => '@fahrenheit'}, binding)		

		puts('@centigrade: ' + @centigrade.to_s)
		puts('@fahrenheit: ' + @fahrenheit.to_s)
	end

	# def example
	# 	cent = 20.0
	#	fahr = 130.5
	#
	#	CentFahrRel.bind({:c => 'cent', :f => 'fahr'}, binding)
	#
	#	puts('cent: ' + cent.to_s)
	#	puts('fahr: ' + fahr.to_s)
	# end
end