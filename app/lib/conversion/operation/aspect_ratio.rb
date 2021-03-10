class Conversion::Operation::AspectRatio
  # There are too many possible height width combinations that could conflict
  # so we need to get the current dimensions of the image and see if we can
  # make the proper changes.
  # @author David J. Davis
  # @return [Boolean]
  def self.perform(image, params)
    original_dimension = MiniMagick::Image.open(image).dimensions
    height = params.fetch('image_height').to_i
    width = params.fetch('image_width').to_i

    return original_dimension if height.zero? && width.zero?

    if height.zero? && width.positive?
      height = find_height(width, original_dimension[0],
                           original_dimension[1])
    end

    if width.zero? && height.positive?
      width = find_width(height, original_dimension[0],
                         original_dimension[1])
    end

    [width, height]
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
