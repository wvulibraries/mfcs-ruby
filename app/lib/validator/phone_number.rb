# app/lib/validator/phone_number.rb

# Validates that a given input matches a phone number
class Validator::PhoneNumber
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

    @input.match?(/\A1?[-. ]?(\(\d{3}\)?[-. ]?|\d{3}?[-. ]?)?\d{3}?[-. ]?\d{4}\z/)
  end
end
