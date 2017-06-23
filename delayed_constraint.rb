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
		DelayedConstraint.new(@@constraints[constraint_name.to_sym]).bind(bindings, context, :_always)
	end

	def once(constraint_name, bindings, context)
		DelayedConstraint.new(@@constraints[constraint_name.to_sym]).bind(bindings, context, :_once)
	end
	
	def _once(*args, &block)
	    constraint = _always(*args, &block)
	    constraint.disable
	    constraint
 	end
end

class DelayedConstraint
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
