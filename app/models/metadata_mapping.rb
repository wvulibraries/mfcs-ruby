class MetadataMapping < ApplicationRecord
  # Concerns
  # -----------------------------------------------------
  include Readonly

  # Enums
  # -----------------------------------------------------
  enum schema: { '0' => 'Dublin Core' }

  # Associations
  # -----------------------------------------------------
  # belongs_to :field
end
