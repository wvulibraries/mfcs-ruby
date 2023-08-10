class AddFieldToMetadataMapping < ActiveRecord::Migration[5.2]
  def change
    add_reference :metadata_mappings, :field, foreign_key: true
  end
end
