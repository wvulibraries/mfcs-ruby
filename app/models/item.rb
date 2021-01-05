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

  # References the custom validation actor. Calling the actor on each field
  # except for file fields gives us a validation on this model.
  # @author David J. Davis
  # @return [Object] Sets form to an Active Record Object
  def custom_data_entry
    data.each do |field, input|
      next if form.file_fields.include? field

      valid = Validator::Actor.new(form.id, field, input).perform
      unless valid[:status] == true || valid[:status].nil?
        errors.add(field, valid[:errors].join(' '))
      end
    end
  end
end
