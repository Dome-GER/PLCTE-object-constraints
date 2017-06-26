require_relative '../delayed_constraint'
require 'libz3'

class DressCode
    constraint :in_colors, "{ :c.in @colors }"
    # Task 1: Change constraint definition
    # constraint :primary_color, "{ :c == 'black'.to_sym }"
    constraint :primary_color, "{ :c == 'blue'.to_sym }"
    constraint :has_basic_color, "{ :c.in @basic_colors }"
    # Task 3: Add has_accent_color constraint
    # constraint :has_accent_color, "{ :c.in @accent_colors }"

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

        always :in_colors, { :c => :@jacket }, binding
        always :in_colors, { :c => :@shirt }, binding
        always :in_colors, { :c => :@tie }, binding
        always :in_colors, { :c => :@pants }, binding
        always :in_colors, { :c => :@belt }, binding
        always :in_colors, { :c => :@shoes }, binding
    end

    def outfit_rules
        # Accessoires should fit
        always :eq, { :c1 => :@belt, :c2 => :@tie }, binding

        # Task 2: Suit color should be consistent
        # always :eq, { :c1 => :@jacket, :c2 => :@pants }, binding

        # Same color for shirt and pants not allowed
        always :not_eq, { :c1 => :@shirt, :c2 => :@pants }, binding

        # Color of pants should be fixed to primary color
        always :primary_color, { :c => :@pants }, binding
        always :primary_color, { :c => :@jacket }, binding

        # Shoes have a plain color
        always :has_basic_color, { :c => :@shoes }, binding

        # Task 3: Add constraint trigger has_accent_color
        # always :has_accent_color, { :c => :@tie }, binding

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
d.change_style({shirt: :light_blue})

# Tasks
# 1. Primary color is changed to black instead of blue -> Change constraint definition in one place instead of multiple places
# 2. Jacket should have the same color as the pants -> Reuse eq constraint & binding
# 3. Set accent color for tie -> Add constraint for accent color
# Missing
# 4. Shoes do not need to have a basic color any longer but the belt always has to -> Change once to always and change variable binding explicitly (without reusage)