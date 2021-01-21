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

  # Audits
  # -----------------------------------------------------
  audited max_audits: 2

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

  validate :valid_form_type, :valid_metadata_form, :valid_object_form

  # Associations
  # -----------------------------------------------------
  has_many :permissions

  # Viewers, Creators, Admins, and Contacts Methods for Permissions System
  has_many :viewers, -> { where(permission: :viewer) }, class_name: 'Permission'
  has_many :admins, -> { where(permission: :admin) }, class_name: 'Permission'
  has_many :contacts, -> { where(permission: :contact) }, class_name: 'Permission'
  has_many :creators, -> { where(permission: :creator) }, class_name: 'Permission'

  has_many :items

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

  # Determines if the form is an object form
  # @author David J. Davis
  # return boolean 
  def object_form? 
    self.metadata == false
  end 

  # Determines if the form is a metadata 
  # @author David J. Davis
  # return boolean 
  def metadata? 
    self.metadata == true 
  end 

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
    self[:fields].to_json if self[:fields].present?
  end
  alias :fields_json :fields

  # Returns as a fields hash for use in views that aren't javascript produced.
  # @author David J. Davis
  # @return ruby hash
  def fields_hash
    self[:fields]
  end

  # This creates a searchable, and quickly extractable version of the hashes.
  # @author David J. Davis
  # @return Set of strings
  def organized_hash
    @organized_hash ||= begin
      tmp_hash = {}
      self[:fields].each do |field|
        tmp_hash[field['name']] = field
      end
      tmp_hash.with_indifferent_access
    end
  end

  # Creates a set of strings that are associated with the fieldnames
  # We need the field names in this way so we can easily see what needs
  # validation for making sure there are no duplicates.
  # @author David J. Davis
  # @return Set of strings
  def check_duplicates
    @check_duplicates ||= begin
      name_set = Set.new
      self[:fields].each do |field|
        name_set.add(field['name']) if field['no_duplicates'] == 'true'
      end
      name_set
    end
  end

  # Returns a set of names that are file fields.
  # @author David J. Davis
  # @return Set of strings
  def file_fields
    @file_fields ||= begin
      file_set = Set.new
      self[:fields].each do |field|
        next unless field['type'] == 'file'

        file_set.add(field['name'])
      end
      file_set
    end
  end

  # This creates a set of strings that are associated with validations.
  # This will make testing if a validaiton needs to take place very fast.
  # @author David J. Davis
  # @return Set of strings
  def check_validations
    @check_validations ||= begin
      validation_set = Set.new
      self[:fields].each do |field|
        if field['validation'].present? || field['validation_regex'].present?
          validation_set << field['name']
        end
      end
      validation_set
    end
  end

  # Loops through fields until the idno field is grabbed
  # Should only be one so the field is returned directly from the loop
  # @author David J. Davis
  # @return Set of strings
  def idno_field 
    return nil if self.metadata?
    self[:fields].each do |field|
      return field if field['type'] == 'idno'
    end
  end 

  # This grabs associated metadata fields for the forms.
  # @author David J. Davis
  # @return Set of strings
  def associated_metadata_forms
    forms_set = Set.new # use set so we
    self[:fields].each do |field|
      next unless %w[dropdown multiselect select].include? field['type']

      if field['choice_type'] == 'link_to_form' && field['choice_form'].present?
        forms_set.add(field['choice_form'])
      end
    end

    Form.find(forms_set.to_a)
  end

  private
  # Sets an error message if metadata is nil which it should never be.
  # @author David J. Davis
  # @abstract add errors and changes .valid? bool
  def valid_form_type
    if metadata.nil?
      errors.add('field', 'Some how the Metadata and Object Fields have not been set, please resubmit the form.')
    end   
  end

  # Checks form type, metadata?, then counts the number fields.
  # @author David J. Davis
  # @abstract add errors and changes .valid? bool
  def valid_metadata_form
    if metadata? && (self.fields_hash.count < 1) 
      errors.add('field', 'Metadata forms must contain at least one field, please add a field')
    end 
  end 

  # Checks form type, object_form?, then counts the number fields.
  # @author David J. Davis
  # @abstract add errors and changes .valid? bool
  def valid_object_form
    if object_form? && (self.fields_hash.count <= 2)
      errors.add('field', 'Object forms must contain at least 2 fields one of them being an idno field.')
    end 
  end 

  # References a method to check for duplicate names in the fields. 
  # @author David J. Davis
  # @abstract add errors and changes .valid? bool
  def valid_field_names 
    errors.add('fields', 'Field names must not be the same. Please check the names of all form fields.') if has_duplicate_names?
  end 
  
  # Plucks the name from all fields.
  # @author David J. Davis
  # @return [Boolean]
  def has_duplicate_names?
    names = fields_hash.pluck('name')
    names.uniq.length != names.length
  end 

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
