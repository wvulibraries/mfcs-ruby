class User < ApplicationRecord
  # Concerns
  # -----------------------------------------------------
  include Readonly

  # Devise Authentication
  # -----------------------------------------------------
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable, :trackable, :omniauthable, :omniauth_providers => [:cas]

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
  enum status: %i[user editor admin]
end
