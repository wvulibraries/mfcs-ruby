class CreateMedia < ActiveRecord::Migration[6.0]
  def change
    create_table :media do |t|
      t.string :uuid
      t.integer :form_id
      t.integer :item_id
      t.string :filename
      t.string :path
      t.bigint :size
      t.string :checksum
      t.jsonb :errors
      t.boolean :virus_scanned
      t.string :mime_type
      t.timestamps
    end
  end
end
