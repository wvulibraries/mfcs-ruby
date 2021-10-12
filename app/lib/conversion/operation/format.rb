# Operation Class
# Used in Conversion::Image
class Conversion::Operation::Format
  # Always check or change the format, if none provided we will turn to a JPG.
  # @author David J. Davis
  # @return [Boolean]
  def self.matches?(params)
    true
  end

  # Takes params and sets them or sets a default value
  # @author David J. Davis
  def initialize(params)
    @format = (params.fetch('image_format') || 'jpg').downcase
  end

  # Uses the conversion object in the MiniMagic conversion to change the format binary wise.
  # @author David J. Davis
  # @return [String]
  def call(convert)
    convert.format(@format)
  end
end
