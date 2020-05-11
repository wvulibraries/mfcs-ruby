class Watermark < ApplicationRecord
  # Concerns
  # -----------------------------------------------------
  include Readonly

  # Validations
  # -----------------------------------------------------
  validates :name,
            presence: true,
            length: { within: 1..250 }

  # Attached Image Using Active Storage
  # -----------------------------------------------------
  has_one_attached :image
end
