# simply connects fields with common logic.
module Fieldable
  extend ActiveSupport::Concern
  included do
    # validations
    validates_presence_of :name, :label, :type
    # associations
    has_one :form, through: :field
    has_one :field, as: :field_types
  end
end
