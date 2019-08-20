class MetadataMapping < ApplicationRecord
  # Concerns
  # -----------------------------------------------------
  include Readonly
  
  # Enums
  # -----------------------------------------------------
  enum schema: { '0' => 'Dublin Core' }
end
