# Alternate version of send+more=money cryptarithmetic puzzle.
# In this version we use separate variables for s,e,n etc.
# This is attempting to follow the code in the SWI Prolog manual:
#  http://www.swi-prolog.org/man/clpfd.html


require "libz3"
require "libarraysolver"
require_relative 'delayed_constraint'

# We are now able to declare constraints here
DelayedConstraint.constraint(:digit_between, "always { [ss,e,n,d,m,o,r,yy].ins(0..9) }")
DelayedConstraint.constraint(:digits_different, "always { [ss,e,n,d,m,o,r,yy].alldifferent? }")
DelayedConstraint.constraint(
	:send_more,
	"always {   ss*1000 + e*100 + n*10 + d +
     		    m*1000 + o*100 + r*10 + e ==
 	m*10000 + o*1000 + n*100 + e*10 + yy }"
)
DelayedConstraint.constraint(:greater_zero, "always { x>0 }")

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

# initialize each variable to an integer so that the solver knows its type
class SMM
	attr_reader :ss, :e, :n, :d, :m, :o, :r, :yy
	def initialize
		@ss,@e,@n,@d,@m,@o,@r,@yy = [0]*8

		# each digit is between 0 and 9
		#always { [s,e,n,d,m,o,r,y].ins(0..9) } 
		DelayedConstraint.digit_between({:ss => :@ss, :e => :@e, :n => :@n, :d => :@d, :m => :@m, :o => :@o, :r => :@r, :yy => :@yy}, binding)

		# all digits are different
		#always { [s,e,n,d,m,o,r,y].alldifferent? }
		DelayedConstraint.digits_different({:ss => :@ss, :e => :@e, :n => :@n, :d => :@d, :m => :@m, :o => :@o, :r => :@r, :yy => :@yy}, binding)

		#always {   s*1000 + e*100 + n*10 + d +
		#           m*1000 + o*100 + r*10 + e ==
		#m*10000 + o*1000 + n*100 + e*10 + y }
		DelayedConstraint.send_more({:ss => :@ss, :e => :@e, :n => :@n, :d => :@d, :m => :@m, :o => :@o, :r => :@r, :yy => :@yy}, binding)

		# the leading digits can't be 0
		#always { s>0 }
		#always { m>0 }
		DelayedConstraint.greater_zero({:x => :@ss}, binding)
		DelayedConstraint.greater_zero({:x => :@m}, binding)

		puts ("solution: [ss,e,n,d,m,o,r,yy] = " + [ss,e,n,d,m,o,r,yy].to_s)
	end
end

t = SMM.new