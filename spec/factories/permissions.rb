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
FactoryBot.define do
  factory :permission do
    association :user, factory: [:user, :basic], strategy: :build
    association :form, factory: :form, strategy: :build
    permission { rand(1..4) }
  end
end
