# Validates alpha numerical characters with spaces
# @author David J. Davis
class Validator::AlphaNumericSpace
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
    @input.match?(/\A[\sa-z0-9]+\z/i)
  end
end
