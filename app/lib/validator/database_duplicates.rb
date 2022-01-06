# app/lib/validator/database_duplicates.rb

# Validator Database Duplicates
class Validator::DatabaseDuplicates
  # include active model for validations to make error tracking easy
  include ActiveModel::Model

  # set needed fields
  attr_accessor :form_id, :field_name

  # Basic constructor for all Validator Methods
  # @author David J. Davis
  def initialize(form_id, field_name)
    @form_id = form_id
    @field_name = field_name
    duplicate_items
  end

  # The perform method of all the classes in the Validator Namespace should be
  # the evaluation of the task at hand.
  #
  # @author David J. Davis
  # @return [Boolean]
  def perform
    @duplicate_items.count.zero?
  end

  # Is an array of duplicate items that is created upon init
  # This helps to determine the validation, but can also be
  # used in displaying records.
  #
  # @author David J. Davis
  # @return [Array]
  def duplicate_items
    prepared_query = ApplicationRecord.sanitize_sql_array(['data->:field_name',
                                                           { field_name: @field_name }])
    @duplicate_items = Item.where(form_id: @form_id)
                           .pluck(Arel.sql(prepared_query))
                           .group_by { |e| e }
                           .select { |_k, v| v.size > 1 }
                           .map(&:first)
  end

  # An active record query of the duplicate items.
  #
  # @author(s) David J. Davis / Tracy A. McCormick
  # @return [ActiveRecord]
  def records
    return nil if @duplicate_items.blank?

    @records ||= Item.where(form_id: @form_id)
                     .where('data ->> :field_name IN (:values)',
                            field_name: @field_name,
                            values: @duplicate_items)
                     .order(Arel.sql("data ->> ':field_name'"))
  end
end
