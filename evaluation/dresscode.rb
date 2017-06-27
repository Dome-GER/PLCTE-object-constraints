require_relative '../delayed_constraint'
require 'libz3'

class DressCode
    constraint :in_colors, "{ :cl.in :colors }"
    # Task 1: Change constraint definition
    # constraint :primary_color, "{ :c == 'black'.to_sym }"
    constraint :primary_color, "{ :c == 'blue'.to_sym }"
    # Task 4: Add secondary color constraint
    # constraint :secondary_color, "{ :c == 'green'.to_sym }"
    
    constraint :eq, "{ :c1 == :c2 }"
    constraint :not_eq, "{ :c1 != :c2 }"

    def initialize
        @colors = [:black, :blue, :light_blue, :white, :red, :green, :brown, :yellow, :gray];
        @basic_colors = [:brown, :black, :gray]
        @accent_colors = [:red, :blue, :yellow, :green]


        # Necessary initializations for solver, ignore this
        @jacket = 0
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
        # Task 2: Change variable bindings
        # always :in_colors, { :cl => :@belt, :colors => :@basic_colors }, binding
        # always :in_colors, { :cl => :@shoes, :colors => :@basic_colors }, binding
        always :in_colors, { :cl => :@belt, :colors => :@colors }, binding
        always :in_colors, { :cl => :@shoes, :colors => :@colors }, binding

        # Belt should fit shoes
        always :eq, { :c1 => :@belt, :c2 => :@shoes }, binding

        # Task 3: Suit color should be consistent
        # always :eq, { :c1 => :@jacket, :c2 => :@pants }, binding

        # Same color for shirt and pants not allowed
        always :not_eq, { :c1 => :@shirt, :c2 => :@pants }, binding

        # Color of pants should be fixed to primary color
        always :primary_color, { :c => :@jacket }, binding
        always :primary_color, { :c => :@pants }, binding

        # Task 4: Add constraint trigger secondary_color
        # once :secondary_color, { :c => :@tie }, binding

        # Task 5: Change once to always
        # always :secondary_color, { :c => :@tie }, binding

        print_outfit __method__
    end

    def change_style(style)
        @jacket = style[:jacket] if style[:jacket];
        @shirt = style[:shirt] if style[:shirt];
        @tie = style[:tie] if style[:tie];
        @pants = style[:pants] if style[:pants];
        @belt = style[:belt] if style[:belt];
        @shoes = style[:shoes] if style[:shoes];

        print_outfit __method__
    end

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
# 1. Primary color is changed to black instead of blue -> Change constraint definition in one place instead of multiple places
# 2. Shoes and belt should always be in basic colors -> Change variable bindings exactly (without reusage)
# 3. Jacket should have the same color as the pants -> Reuse eq constraint & binding
# 4. Tie should have the secondary color 'blue' initially -> Add constraint for accent color
# 5. Tie should always have the secondary color instead of any color -> Change once to always and constraint usage
