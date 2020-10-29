# The perform method of all the classes in the Validator
# Namespace should be the evaluation of the task at hand.
# RETURNS TRUE if there are no duplicates present.
# RETURNS FALSE if there are duplicates present.
class Validator::FieldDuplicate
  include ActiveModel::Model
  define_model_callbacks :initialize, only: :after

  # after init do this
  after_initialize :field_data

  # Basic constructor for all Validator Methods
  # @author David J. Davis
  def initialize(input, field_info, form_id)
    @field_info = field_info
    @input = input
    @form_id = form_id
    run_callbacks :initialize
  end

  # Peform function is in all validator classes and returns
  # make the actual validation check to return a boolean.
  #
  # @author David J. Davis
  # @return [Boolean]
  def perform
    return true unless required? && no_duplicates?

    @field_data.exclude? @input
  end

  # This will check to see if the field data has the filed info as required
  #
  # @author David J. Davis
  # @return [Boolean]
  def required?
    @field_info['required'].to_s.casecmp('true').zero?
  end

  # checks the field data to see if the info is not allowed to have duplicates
  #
  # @author David J. Davis
  # @return [Boolean]
  def no_duplicates?
    @field_info['no_duplicates'].to_s.casecmp('true').zero?
  end

  # The query plucks a sanitized parameter from the fieldname
  # based on the one given for the field_data.
  #
  # @author David J. Davis
  # @return [Set]
  def field_data
    prepped_pluck = ApplicationRecord.sanitize_sql_array(['data->:field_name', { field_name: @field_info['name'] }])
    items = Item.where(form_id: @form_id).pluck(Arel.sql(prepped_pluck))
    @field_data = items.to_set
  end
end
