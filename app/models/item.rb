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
end
