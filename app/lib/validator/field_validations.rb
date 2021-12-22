# This namespaced under the validator class evaluates the fields validations
# This was broken out of the actor class as a way to keep each class having
# one clear responsibility.
class Validator::FieldValidations
  # Basic constructor for all Validator Methods
  # @author David J. Davis
  def initialize(field_info)
    @field_info = field_info
  end

  # Return the validations needed to populate the validation array
  # @author David J. Davis
  # @return [Array]
  def validations
    validations = []
    validations << 'required' if required?
    validations << 'text_length' if text_validation?
    validations << 'integer_between' if integer_validation?
    validations << 'integer_step' if step_validation?
    validations << 'field_duplicates' if duplicates?
    validations << @field_info['validation'] if validation?
    validations
  end

  # Checks to see if there is a text_validation to perform.
  # @author(s) David J. Davis, Tracy A. McCormick
  # @return [Boolean]
  def text_validation?
    text_fields = %w[text textarea wysiwyg]
    text_fields.include?(@field_info['type']) && (@field_info['min'].present? || @field_info['max'].present?)
  end

  # Checks to see if there is a integer validation to perform.
  # @author(s) David J. Davis, Tracy A. McCormick
  # @return [Boolean]
  def integer_validation?
    numeric_fields = %w[number integer]
    numeric_fields.include?(@field_info['type']) && (@field_info['min_number'].present? || @field_info['max_number'].present?)
  end

  # Checks to see if there is a step validation to perform.
  # @author(s) David J. Davis, Tracy A. McCormick
  # @return [Boolean]
  def step_validation?
    numeric_fields = %w[number integer]
    numeric_fields.include?(@field_info['type']) && @field_info['step'].present?
  end

  # Checks to see if the form field validation is present
  # @author David J. Davis
  # @return [Boolean]
  def validation?
    @field_info['validation'].present?
  end

  # Checks to see if a duplication needs to happen.
  # @author David J. Davis
  # @return [Boolean]
  def duplicates?
    @field_info['no_duplicates'].to_s == 'true' && @field_info['required'].to_s == 'true'
  end

  # Checks to see the field is required and needs that validation
  # @author David J. Davis
  # @return [Boolean]
  def required?
    @field_info['required'].to_s == 'true'
  end
end
