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