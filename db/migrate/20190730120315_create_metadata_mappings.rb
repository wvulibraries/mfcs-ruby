class CreateMetadataMappings < ActiveRecord::Migration[5.2]
  def change
    create_table :metadata_mappings do |t|
      t.integer :schema
      t.string :identifier
      t.string :qualifier
      t.timestamps
    end
  end
end
