class FileField < ApplicationRecord
  # Concerns
  # -----------------------------------------------------
  include Fieldable

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
    self.type ||= 'file'
    # set bools
    self.public_release ||= true
  end
end
