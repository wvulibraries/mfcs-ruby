# == Schema Information
#
# Table name: projects
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  project_id :string
#
FactoryBot.define do
  factory :project do
    name { "MyString" }
    project_id { "MyString" }
  end
end
