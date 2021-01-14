# == Schema Information
#
# Table name: items
#
#  id             :bigint           not null, primary key
#  data           :jsonb
#  idno           :string
#  metadata       :boolean
#  public_release :boolean
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

  # Audits
  # -----------------------------------------------------
  audited max_audits: 50

  # Validations
  # -----------------------------------------------------
  validate :custom_data_entry

  # Callbacks
  # -----------------------------------------------------
  before_save :idno_setups, unless: proc { idno_set? }

  # References the custom validation actor. Calling the actor on each field
  # except for file fields gives us a validation on this model.
  # @author David J. Davis / Tracy McCormick
  # @abstract not really a return value, it is checked by the valid? model.
  def custom_data_entry
    return true if data.blank?
    if persisted? && changed? 
      return true unless changes[:data]
      validate_data(changed_data)
    else
      validate_data(data)
    end 
  end 

  # References the custom validation actor. Calling the actor on each field
  # except for file fields gives us a validation on this model.
  # @author David J. Davis
  # @return [truthy] possible return of IDNO
  def idno_setups
    # skips the hole process if a metadata form
    return if form.metadata?

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
    idno.present? && form.object_form?
  end

  private 
    # This method loops through the data to use the Validator Actor
    # If there is not valid then add to the errors field.
    # @author David J. Davis / Tracy McCormick
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
      changes[:data][0].each {|key, value| new_validations[key] = changes[:data][1][key] if changes[:data][1][key] != value }
      new_validations
    end 
end
