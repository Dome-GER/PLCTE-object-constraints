require 'libz3'

class Object
	@@constraints = {}

	def self.constraint(name, definition)
		@@constraints[name] = definition
	end

	def constraint(name, definition)
		self.class.constraint(name, definition)
	end

	alias_method :_always, :always
	def always(constraint_name, bindings, context)
		DelayedConstraint.send constraint_name.to_sym, bindings, context, :_always
	end
end

class DelayedConstraint
	def self.method_missing(name, bindings, context, type)
    	unless @@constraints.key?(name.to_sym)
    		raise ArgumentError, "Constraint does not exist"
    	end

    	self.new(@@constraints[name]).bind(bindings, context, type)
  	end

	attr_reader :constraint
	def initialize(constraint_definition)
		@constraint = constraint_definition
	end

	def bind(bindings, context, type)
		unless bindings.nil?
			bindings.each do |key, value| 
				@constraint = constraint.gsub(":#{key.to_s}", value.to_s)
			end
		end
		eval("#{type} #{constraint}", context)
	end
end
