class SelectField < ApplicationRecord
  # Concerns
  # -----------------------------------------------------
  include Fieldable
  include Readonly

  # Enums
  # -----------------------------------------------------
  enum choice_type: %i[manual form]

  # RAILS CALLBACKS
  # -----------------------------------------------------
  # default values
  after_initialize :set_defaults

  private
  # Providing default values for the feild for rendering.
  # @author David J. Davis
  # @abstract
  # @return truthy
  def set_defaults
    # set strings
    self.name ||= 'untitled'
    self.label ||= 'Untitled'
    self.type ||= 'select'
    self.choice_type ||= 'manual'
    # set bools
    self.public_release ||= true
  end
end
