# == Schema Information
#
# Table name: systems
#
#  id         :bigint           not null, primary key
#  name       :string
#  value      :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :system do
    name { "MyString" }
    value { false }
  end
end
