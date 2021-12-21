class Conversion::Operation::Resolution
  # Sets resolution if it exists or doesn't exist
  # @author David J. Davis
  # @return [Boolean]
  def self.matches?(_params)
    true # always run this method
  end

  # Get only the necessary params and assign a default if needed.
  # @author David J. Davis
  # @abstract
  def initialize(params)
    @resolution = (params['image_resolution'] || '72').to_i
  end

  # Calls the density function on the minimagick class instance
  # @author David J. Davis
  # @abstract
  def call(convert)
    convert.density(@resolution)
  end
end
