# == Schema Information
#
# Table name: items
#
#  id             :bigint           not null, primary key
#  created_by     :integer
#  data           :jsonb
#  idno           :string
#  metadata       :boolean
#  modified_by    :integer
#  public_release :boolean
#  uuid           :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  form_id        :integer
#
class Item < ApplicationRecord
  # Context
  # -----------------------------------------------------
  include Readonly

  # Associations
  # -----------------------------------------------------
  belongs_to :form
  has_many :media

  # Audits
  # -----------------------------------------------------
  audited max_audits: 50

  # Validations
  # -----------------------------------------------------
  validate :custom_data_entry

  # Callbacks
  # -----------------------------------------------------
  after_initialize :set_defaults, unless: :persisted?
  before_save :idno_setups, unless: proc { idno_set? }

  # temporary
  # after_save :processing

  # References the custom validation actor. Calling the actor on each field
  # except for file fields gives us a validation on this model.
  # @author David J. Davis
  # @return [truthy] possible return of IDNO
  def idno_setups
    # skips the hole process if a metadata form
    return if form.nil? || form.metadata?

    idno_settings = form.idno_field
    if idno_settings['managed_by'].to_s.casecmp('system').zero?
      idno_number = Idno::SystemIdno.new(form.id, idno_settings).formatted_idno
      self.idno = idno_number
      data['idno'] = idno_number
    elsif idno_settings['managed_by'].to_s.casecmp('user').zero?
      self.idno = data['idno']
    end
  end

  # Boolean for Proc Method used on after_save callback
  # This should keep the idno evaluations from happening more than once.
  # @author David J. Davis
  # @return [Boolean]
  def idno_set?
    return true if persisted?

    idno.present? && form.object_form?
  end

  # References the custom validation actor. Calling the actor on each field
  # except for file fields gives us a validation on this model.
  # @author David J. Davis / Tracy McCormick
  # @abstract not really a return value, it is checked by the valid? model.
  def custom_data_entry
    return true if data.blank?

    if persisted?
      return true unless changes[:data]

      validate_data(changed_data)
    else
      validate_data(data)
    end
  end

  # Paths for variety of Media
  # -----------------------------------------------------
  # Archival Path
  # Files should be stored here and then never used again.
  # @author David J. Davis
  # @return [String]
  def archival_path
    Rails.root.join(Rails.configuration.mfcs['data_store'], form_id.to_s, uuid_path, 'archives')
  end
  alias archive_path archival_path

  # Working Path
  # A duplicate of the file in the archival path that should be
  # used for conversions and in system use.
  # @author David J. Davis
  # @return [String]
  def working_path
    Rails.root.join(Rails.configuration.mfcs['data_store'], form_id.to_s, uuid_path, 'working')
  end

  # Conversion Path
  # The path where conversions will be stored
  # @author David J. Davis
  # @return [String]
  def conversion_path
    Rails.root.join(Rails.configuration.mfcs['data_store'], form_id.to_s, uuid_path, 'conversions')
  end

  # Thumb Path
  # The path where conversions will be stored
  # @author David J. Davis
  # @return [String]
  def thumbnail_path
    Rails.root.join(Rails.configuration.mfcs['data_store'], form_id.to_s, uuid_path, 'conversions', 'thumb')
  end
  alias thumb_path thumbnail_path

  # Export
  # The path where exports will be stored.
  # @author David J. Davis
  # @return [String]
  def export_path
    Rails.root.join(Rails.configuration.mfcs['data_store'], form_id.to_s, uuid_path, 'exports')
  end

  # Splits the UUID into a path string
  # @author David J. Davis
  # @return [String]
  def uuid_path
    uuid.tr('-', '/')
  end

  # Callback Methods
  # -----------------------------------------------------

  def processing
    ProcessingJob.perform_later(id)
  end

  # The helper methods to set default values
  # @author David J. Davis
  # @abstract
  def set_defaults
    self.uuid ||= SecureRandom.uuid
  end

  # returns the id of the first thumbnail media image
  # @author Tracy A. McCormick
  # @return integer
  def thumb_id
    begin
      media = Media.where(item_id: id, media_type: 'thumbnail').first
      media.id
    rescue
      -1
    end
  end

  # returns the count of files in the passed field
  # @author Tracy A. McCormick
  # @return integer  
  def file_field_count(field)
    begin
      self['data'][field].count
    rescue
      0
    end
  end 

  private

  # This method loops through the data to use the Validator Actor
  # If there is not valid then add to the errors field.
  # @author David J. Davis / Tracy A. McCormick
  # @abstract Sets errors to the item model
  def validate_data(validation_data)
    validation_data.each do |field, input|
      next if form.file_fields.include? field

      valid = Validator::Actor.new(form.id, field, input).perform
      unless valid[:status] == true || valid[:status].nil?
        errors.add(field, valid[:errors].join(' '))
      end
    end
  end

  # This method loops through the data to see if the data has changed
  # from the persisted methods.
  # @author David J. Davis
  # @return [Hash]
  def changed_data
    new_validations = {}
    changes[:data][0].each do |key, value|
      new_validations[key] = changes[:data][1][key] if changes[:data][1][key] != value
    end
    new_validations
  end

  protected

  def timestamp_attributes_for_create
    [:updated_at]
  end  
end
