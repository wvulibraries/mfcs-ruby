class AddIndextoJsonField < ActiveRecord::Migration[5.2]
  def change
    add_index :forms, :fields, using: :gin
  end
end
