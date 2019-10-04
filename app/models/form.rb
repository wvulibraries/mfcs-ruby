# Form class which we be a base class for building forms.
class Form < ApplicationRecord
  # Concerns
  # -----------------------------------------------------
  include Readonly

  # Validations
  # -----------------------------------------------------
  validates :title,
            presence: true,
            length: { within: 1..250 },
            uniqueness: true

  validates :display_title,
            presence: true,
            length: { within: 1..250 },
            uniqueness: true

  # Associations
  # -----------------------------------------------------
  has_many :fields, dependent: :destroy

  # Form Helpers
  # -----------------------------------------------------
  accepts_nested_attributes_for :fields

  # RAILS CALLBACKS
  # -----------------------------------------------------
  after_initialize :set_defaults

  private
  # Setting some defaults for the forms to match current behaviors
  # of the existing app. These will be the defaults.
  # @author David J. Davis
  # @abstract
  # @return truthy
  def set_defaults
    # set strings
    self.submit_button ||= 'Submit'
    self.update_button ||= 'Update'
    # set bools
    self.container ||= false
    self.production ||= true
    self.export_public ||= true
    self.export_oai ||= true
  end
end
