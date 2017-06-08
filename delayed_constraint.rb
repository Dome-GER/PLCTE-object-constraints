require 'libz3'

class DelayedConstraint
	@@constraints = {}

	def self.constraint(identifier, constraint_definition)
		@@constraints[identifier] = constraint_definition
	end

	def self.method_missing(name, param_binding, context)
    	unless @@constraints.key?(name.to_sym)
    		raise ArgumentError, "Constraint does not exist"
    	end

    	self.new(@@constraints[name]).bind(param_binding, context)
  	end

	attr_reader :constraint
	def initialize(constraint_definition)
		@constraint = constraint_definition
	end

	def bind(params, context)
		unless params.nil?
			params.each do |key, value| 
				@constraint = constraint.sub(key.to_s, value.to_s)
			end
		end
		eval(constraint, context)
	end
end
