require_relative '../delayed_constraint'
require 'libz3'

class DressCode
    # cl, c, c1, c2 abbreviations for 'clothing'
    constraint :in_colors, "{ :cl.in :colors }"
    constraint :has_primary_color, "{ :c == 'blue'.to_sym }"
    constraint :equal_colors, "{ :c1 == :c2 }"
    constraint :not_equal_colors, "{ :c1 != :c2 }"

    def initialize
        @colors = [:black, :white, :green, :blue, :light_blue, :red, :brown, :yellow, :gray];
        @basic_colors = [:brown, :black, :gray]


        # Necessary initializations for solver, ignore this
        @jacket = 0 # @jacket = :white
        @shirt = 0
        @tie = 0
        @pants = 0
        @belt = 0
        @shoes = 0
    end

    def outfit_rules
        always :in_colors, { :cl => :@jacket, :colors => :@colors }, binding
        always :in_colors, { :cl => :@shirt, :colors => :@colors }, binding
        always :in_colors, { :cl => :@tie, :colors => :@colors }, binding
        always :in_colors, { :cl => :@pants, :colors => :@colors }, binding
        always :in_colors, { :cl => :@belt, :colors => :@colors }, binding
        always :in_colors, { :cl => :@shoes, :colors => :@colors }, binding

        always :equal_colors, { :c1 => :@belt, :c2 => :@shoes }, binding

        always :not_equal_colors, { :c1 => :@shirt, :c2 => :@pants }, binding

        always :has_primary_color, { :c => :@jacket }, binding
        always :has_primary_color, { :c => :@pants }, binding

        print_outfit __method__
    end

    # not relevant
    def change_style(style)
        @jacket = style[:jacket] if style[:jacket];
        @shirt = style[:shirt] if style[:shirt];
        @tie = style[:tie] if style[:tie];
        @pants = style[:pants] if style[:pants];
        @belt = style[:belt] if style[:belt];
        @shoes = style[:shoes] if style[:shoes];

        print_outfit __method__
    end

    # not relevant
    def print_outfit(method)
        puts("--#{method}--",
            "jacket: #{@jacket}",
            "shirt: #{@shirt}",
            "tie: #{@tie}",
            "pants: #{@pants}",
            "belt: #{@belt}",
            "shoes: #{@shoes}")
    end
end

d = DressCode.new
# Outfit is recommended to the customer
d.outfit_rules
# Customer can change some clothing
d.change_style({tie: :red})

# Tasks
# 1. Primary color should be black instead of blue
# 2. Shoes and belt should always be one of the basic colors
# 3. Jacket should have the same color as the pants
# 4. Tie should have the secondary color 'blue' at first (once) but could be changed later on
# 5. Tie should always have the secondary color (instead of any possible color as in 4)
