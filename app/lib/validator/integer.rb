# app/lib/validator/integer.rb

# Validator Class that checks Integer values.
class Validator::Integer
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

    integer(@input)
  end

  # Regex to validate the interger and spaces.
  #
  # @param [String] num - the param to evaluate.
  #
  # @author David J. Davis
  # @return [Boolean]
  def integer(num)
    Integer(num)
    true
  rescue ArgumentError, TypeError
    false
  end
end
