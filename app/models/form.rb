# == Schema Information
#
# Table name: forms
#
#  id                            :bigint           not null, primary key
#  container                     :boolean
#  count                         :integer
#  description                   :text
#  display_title                 :string
#  export_oai                    :boolean
#  export_public                 :boolean
#  fields                        :jsonb            is an Array
#  idno                          :jsonb
#  link_title                    :string
#  metadata                      :boolean
#  navigation                    :jsonb            is an Array
#  object_public_release_default :boolean
#  object_public_release_show    :boolean
#  object_title_field            :string
#  permissions                   :jsonb            is an Array
#  production                    :boolean
#  submit_button                 :string
#  title                         :string
#  update_button                 :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#
# Indexes
#
#  index_forms_on_idno  (idno)
#
# Form class which we be a base class for building forms.
class Form < ApplicationRecord
  # Concerns
  # -----------------------------------------------------
  include Readonly

  # Hstores
  # -----------------------------------------------------
  # attr_accessor :fields, :navigation, :permissions, :idno

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
  after_initialize :set_defaults, unless: :persisted?

  # Get an array of linked metadata fields from the field hash
  # @author David J. Davis
  # @return object[Array <Integer>] Array of ids to identify the forms. 
  def linked_forms
    return nil if self.fields.blank? || self.fields.class != Hash

    self.fields.map { |k,v| v }.pluck('choices_form').compact.map(&:to_i)
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
