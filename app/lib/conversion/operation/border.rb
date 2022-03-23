# Operation Class
# Used in Conversion::Image
class Conversion::Operation::Border
  # Function that helps to determine if the operation needs to take place.
  # @author David J. Davis
  # @return [Boolean]
  def self.matches?(params)
    # return false if params are nil
    return false if params.fetch('border').nil?

    params.fetch('border').to_s.casecmp('true').zero?
  end

  # Takes params and sets them or sets a default value
  # @author David J. Davis
  def initialize(params)
    @border_width = (params['border_width'] || '5px')
    @border_color = (params['border_color'] || '#000000')
  end

  # Uses the conversion object in the MiniMagic conversion to .
  # @author David J. Davis
  # @return [String]
  def call(convert)
    convert.bordercolor(@border_color)
    convert.border(@border_width)
  end
end
