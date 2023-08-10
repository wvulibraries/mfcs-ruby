# app/lib/conversion/operation/resize.rb

# Conversion Operation resize class
class Conversion::Operation::Resize
  # Function that helps to determine if the operation needs to take place.
  # @author David J. Davis
  # @return [Boolean]
  def self.matches?(params)
    params.fetch('image_width').present? || params.fetch('image_height').present?
  end

  # Get only the necessary params and assign them as needed
  # @author David J. Davis
  # @abstract
  def initialize(params)
    @width = params.fetch('image_width')
    @height = params.fetch('image_height')
  end

  # Adds the conversion job to the minimagick object.
  # @author David J. Davis
  # @abstract
  def call(convert)
    convert.resize("#{@width}x#{@height}")
  end
end
