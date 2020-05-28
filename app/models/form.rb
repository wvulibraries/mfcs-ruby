# == Schema Information
#
# Table name: forms
#
#  id                            :bigint           not null, primary key
#  container                     :boolean          default(FALSE), not null
#  count                         :integer
#  description                   :text
#  display_title                 :string
#  export_oai                    :boolean          default(FALSE), not null
#  export_public                 :boolean          default(FALSE), not null
#  fields                        :jsonb            is an Array
#  idno                          :jsonb
#  link_title                    :string
#  metadata                      :boolean          default(FALSE), not null
#  navigation                    :jsonb            is an Array
#  object_public_release_default :boolean          default(FALSE), not null
#  object_public_release_show    :boolean          default(FALSE), not null
#  object_title_field            :string
#  permissions                   :jsonb            is an Array
#  production                    :boolean          default(FALSE), not null
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
class Form < ApplicationRecord
  # Concerns
  # -----------------------------------------------------
  include Readonly

  # Hstores
  # -----------------------------------------------------
  # attr_accessor :fields
  # serialize :fields, JSON

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
  has_many :permissions

  # Viewers, Creators, Admins, and Contacts Methods for Permissions System
  has_many :viewers, -> { where(permission: :viewer) }, class_name: 'Permission'
  has_many :admins, -> { where(permission: :admin) }, class_name: 'Permission'
  has_many :contacts, -> { where(permission: :contact) }, class_name: 'Permission'
  has_many :creators, -> { where(permission: :creator) }, class_name: 'Permission'

  # Nested Models
  # ----------------------------------------------------
  accepts_nested_attributes_for :permissions

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
    forms = []
    self[:fields].map { |h| forms.push(h['choice_form']) }
    forms.compact.map(&:to_i)
  end

  # Get an array of linked metadata fields from the field hash
  # @author David J. Davis
  # @return object[JSON] Returns the fields as json array instead ruby hash
  def fields
    self[:fields].to_json unless self[:fields].blank?
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
