# app/lib/validator/ip.rb

# Validator Ip
class Validator::Ip
  # Basic constructor for all Validator Methods
  # @author David J. Davis
  def initialize(input, field_info, form_id)
    @field_info = field_info
    @input = input
    @form_id = form_id
  end

  # Peform function is in all validator classes and returns
  # make the actual validation check to return a boolean.
  #
  # @author David J. Davis
  # @return [Boolean]
  def perform
    return true if @input.blank?

    IPAddr.new(@input)
    true
  rescue IPAddr::InvalidAddressError
    false
  end
end
