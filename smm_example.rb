# Alternate version of send+more=money cryptarithmetic puzzle.
# In this version we use separate variables for s,e,n etc.
# This is attempting to follow the code in the SWI Prolog manual:
#  http://www.swi-prolog.org/man/clpfd.html

require "libz3"
require "libarraysolver"
require_relative 'delayed_constraint'

# We are now able to declare constraints here
constraint :digit_between, "{ [:s,:e,:n,:d,:m,:o,:r,:y].ins(0..9) }"
constraint :digits_different, "{ [:s,:e,:n,:d,:m,:o,:r,:y].alldifferent? }"
constraint :send_more, "{ :s*1000 + :e*100 + :n*10 + :d +
						  :m*1000 + :o*100 + :r*10 + :e ==
 						  :m*10000 + :o*1000 + :n*100 + :e*10 + :y }"
constraint :greater_zero, "{ :x>0 }"

# Constrain each element of the array to be in the provided range
# (Later this should be moved to a finite domain library.)
# This is inefficient with z3 but should be very efficient for a SAT
# solver like kodkod.
class Array
  def ins(range)
    return true if self.empty?
    self[1..-1].ins(range) &&
      self[0] >= range.first &&
      self[0] <= range.last
  end
end

class SMM
	attr_reader :s, :e, :n, :d, :m, :o, :r, :y

	def initialize
		# initialize each variable to an integer so that the solver knows its type
		@s,@e,@n,@d,@m,@o,@r,@y = [0]*8

		bindings = Hash[[:s, :e, :n, :d, :m, :o, :r, :y].map {|v| [v,"@#{v}".to_sym]}]

		# each digit is between 0 and 9
		# always { [s,e,n,d,m,o,r,y].ins(0..9) } 
		always :digit_between, bindings, binding

		# all digits are different
		# always { [s,e,n,d,m,o,r,y].alldifferent? }
		always :digits_different, bindings, binding

		# always {   s*1000 + e*100 + n*10 + d +
		#            m*1000 + o*100 + r*10 + e ==
		# m*10000 + o*1000 + n*100 + e*10 + y }
		always :send_more, bindings, binding

		# the leading digits can't be 0
		# always { s>0 }
		# always { m>0 }
		always :greater_zero, {:x => :@s}, binding
		always :greater_zero, {:x => :@m}, binding

		puts ("solution: [s,e,n,d,m,o,r,y] = " + [s,e,n,d,m,o,r,y].to_s)
	end
end

t = SMM.new
