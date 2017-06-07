require_relative 'delayed_constraint'

class TemperatureConverter

	DelayedConstraint.constraint(:relationFahrCent, "always {c * 1.8 == f - 32.0 }")

	def initialize

		@centigrade = 100.0
		@fahrenheit = 100.0

		DelayedConstraint.relationFahrCent({:c => :@centigrade, :f => :@fahrenheit}, binding)

		puts('@centigrade: ' + @centigrade.to_s)
		puts('@fahrenheit: ' + @fahrenheit.to_s)
	end

	def example
	 	cent = 20.0
		fahr = 130.5
	
		DelayedConstraint.relationFahrCent({:c => :cent, :f => :fahr}, binding)
	
		puts('cent: ' + cent.to_s)
		puts('fahr: ' + fahr.to_s)
	end
end