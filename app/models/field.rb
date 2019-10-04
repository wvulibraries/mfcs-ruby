# This is now a join table for allowing forms to have many fields of different types.
class Field < ApplicationRecord
  # Concerns
  # -----------------------------------------------------
  include Readonly

  # Associations
  # -----------------------------------------------------
  belongs_to :form
  belongs_to :field_types, polymorphic: true

  has_many :metadata_mappings, dependent: :destroy

  # Form Helpers
  # -----------------------------------------------------
  accepts_nested_attributes_for :metadata_mappings
end
