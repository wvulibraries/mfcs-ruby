# Aspect Ratio Calculator.
# Takes numerical heights and widths and calculates what the aspect ratios should be.
# @author David J. Davis
class AspectRatio
  # Initalizes the instance with instance variables casting as integers.
  # @author David J. Davis
  # @abstract
  def initialize(orig_width, orig_height, new_width, new_height)
    @original_width = orig_width.to_i
    @original_height = orig_height.to_i
    @height = new_height.to_i
    @width = new_width.to_i
  end

  # Calcuates the aspect ratios using the instance variables.
  # @author(s) David J. Davis / Tracy A. McCormick
  # @return [Array || Integers] [width,height]
  def calculate
    return [@original_width, @original_height] if @height.zero? && @width.zero?

    if (@height.zero? && @width.positive?) || (@height.positive? && @width.positive?)
      @height = AspectRatio.find_height(@width, @original_width, @original_height)
    end

    if @width.zero? && @height.positive?
      @width = AspectRatio.find_width(@height, @original_width, @original_height)
    end

    [@width, @height]
  end

  # Aspect ratio calculation to find the missing height value
  # @author David J. Davis
  # @return [Integer]
  def self.find_height(width, original_width, original_height)
    width * original_height / original_width
  end

  # Aspect ratio calculation to find the missing width value
  # @author David J. Davis
  # @return [Integer]
  def self.find_width(height, original_width, original_height)
    height * original_width / original_height
  end
end
