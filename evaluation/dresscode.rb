require_relative '../delayed_constraint'
require 'libz3'

class DressCode
    constraint :in_colors, "{ :c.in @colors }"
    constraint :eq, "{ :c1 == :c2 }"
    constraint :not_eq, "{ :c1 != :c2 }"

    def initialize
        # Necessary initializations for solver 
        @colors = [:blue, :black, :brown, :white];
        @hat = 0
        @shirt = 0
        @pants = 0
        @shoes = 0
    end

    def run
        always :in_colors, { :c => :@hat }, binding
        always :in_colors, { :c => :@shirt }, binding
        always :in_colors, { :c => :@pants }, binding
        always :in_colors, { :c => :@shoes }, binding

        always :eq, { :c1 => :@hat, :c2 => :@shoes }, binding
        always :not_eq, { :c1 => :@shirt, :c2 => :@pants }, binding

        puts(@hat, @shirt, @pants, @shoes);

        @shirt = :white;

        puts(@hat, @shirt, @pants, @shoes);
    end
end

d = DressCode.new
d.run