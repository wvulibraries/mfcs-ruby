class Validator::IntegerBetween
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
    min = @field_info['min_number'].to_i
    max = @field_info['max_number'].to_i
    return true if max.zero? || min == max

    @input.to_i.between?(min, max)
  end
end
