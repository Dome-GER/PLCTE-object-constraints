require 'libz3'

class DelayedConstraint
	attr_reader :constraint
	def initialize(constraint_definition)
		@constraint = constraint_definition
	end

	def bind(params, context)
		params.each do |key, value| 
			constraint.replace(constraint.sub(key.to_s, value))
		end
		eval(constraint, context)
	end
end

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

t = TemperatureConverter.new
# t.example