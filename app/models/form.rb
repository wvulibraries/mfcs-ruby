# Form class which we be a base class for building forms.
class Form < ApplicationRecord
  # Concerns
  # -----------------------------------------------------
  include Readonly

  # Hstores
  # -----------------------------------------------------
  store_accessor :fields, :navigation, :permissions, :idno

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
            
  # SCOPES
  # -----------------------------------------------------
  scope :object_forms, -> { where(metadata: 'false').order(:title) }
  scope :metadata_forms, -> { where(metadata: 'true').order(:title) }
  # RAILS CALLBACKS
  # -----------------------------------------------------
  after_initialize :set_defaults

  # Get an array of linked metadata fields from the field hash
  # @author David J. Davis
  # @return object[Array <Integer>] Array of ids to identify the forms. 
  def linked_forms
    self.fields.map { |k,v| v }.pluck('choicesForm').compact
  end

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
