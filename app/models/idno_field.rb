class IdnoField < ApplicationRecord
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
    self.name ||= 'idno'
    self.label ||= 'IDNO'
    self.css_id ||= 'idno'
    self.type ||= 'idno'
    # set bools
    self.required ||= true
    self.no_duplicates ||= true
    self.read_only ||= true
    self.public_release ||= true
    self.oai_release ||= true
    self.sortable ||= true
    self.searchable ||= true
    self.display_in_list ||= true
  end
end