class Validator::IntegerStep
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
    # true if not input
    return true if @input.blank?
    
    # test steps
    num_step = @field_info['step'].to_i
    return true unless num_step.positive? || num_step == 1

    divisible_by_step?(@input.to_i, num_step)
  end

  # Evaluates if the number is divisible by its step counter
  #
  # @param [String] address - The ip string to evaluate.
  #
  # @author David J. Davis
  # @return [Boolean]
  def divisible_by_step?(num, step)
    (num % step).zero?
  end
end
