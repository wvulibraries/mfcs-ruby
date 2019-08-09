# This is now a join table for allowing forms to have many fields of different types. 
class Field < ApplicationRecord
  belongs_to :form
  belongs_to :field_types, polymorphic: true
end
