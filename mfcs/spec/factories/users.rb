# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  active                 :boolean
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :inet
#  email                  :string
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  form_creator           :boolean
#  last_name              :string
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :inet
#  pagination             :integer
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  sign_in_count          :integer          default(0), not null
#  status                 :integer
#  student                :boolean
#  username               :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
FactoryBot.define do
  factory :user do
    sequence(:id) { |n| n }
    email { Faker::Internet.email }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    username { Faker::Internet.username(specifier: 2..20) }
    password { Faker::Internet.password }
    active { true }
    student { false }
    form_creator { false }

    trait :admin do
      status { :admin }
      active { true }
    end

    trait :basic do
      status { :user }
      active { true }
    end

    trait :form_creator do
      status { :user }
      active { true }
      form_creator { true }
    end

    trait :editor do
      status { :editor }
      active { true }
    end

    trait :student do
      status { :user }
      active { true }
      student { true }
    end
  end
end
