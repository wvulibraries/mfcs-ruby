# == Schema Information
#
# Table name: permissions
#
#  id         :bigint           not null, primary key
#  permission :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  form_id    :bigint           not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_permissions_on_form_id  (form_id)
#  index_permissions_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (form_id => forms.id)
#  fk_rails_...  (user_id => users.id)
#
class Permission < ApplicationRecord
  belongs_to :user
  belongs_to :form

  # Concerns
  # -----------------------------------------------------
  include Readonly

  # Enums
  # ----------------------------------------------------
  enum permission: { admin: 3, viewer: 1, creator: 2, contact: 4 }
end
