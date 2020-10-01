class Validator::TextLength < Validator::Base
  # callbacks
  after_initialize :form, :form_field, :default_max, :default_min, :default_format

  def perform
    return true if (min.blank? && max.blank?) || min == max
  end

  # Evaluates if the number is divisible by its step counter
  #
  # @param [String] address - The ip string to evaluate.
  #
  # @author David J. Davis
  # @return [Boolean]
  def divisible_by_step?(num, step)
    return true unless step.present? && step.positive?

    (num % step).zero?
  end

  # Checks possible values to be sure that the validation is ran or skipped
  #
  # @param [String] address - The ip string to evaluate.
  #
  # @author David J. Davis
  # @return [Boolean]
  def between_min_max?(num, min, max)
    num.to_i.between?(min, max)
  end

  def default_min; end

  def default_max; end
end
