# app/lib/validator/no_special_char.rb

# Validator No Special Characters
class Validator::NoSpecialChar
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

    @input.match?(/^[a-z0-9\s]*$/i)
  end
end
