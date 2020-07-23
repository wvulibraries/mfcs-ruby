

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
class User < ApplicationRecord
  # Concerns
  # -----------------------------------------------------
  include Readonly

  # Devise Authentication
  # -----------------------------------------------------
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable, :trackable, :omniauthable, omniauth_providers: [:cas]

  # Validations
  # -----------------------------------------------------
  validates :first_name, presence: true, length: { within: 2..70 }
  validates :last_name, presence: true, length: { within: 2..70 }
  validates :username, presence: true, length: { within: 2..70 }
  # validates :email, presence: true
  # validate  :valid_email

  # Associations
  # -----------------------------------------------------

  # Enums
  # -----------------------------------------------------
  enum status: { user: 0, editor: 1, admin: 2 }

  def name
    first_name + ' ' + last_name
  end
end
