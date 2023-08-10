class IdnoHashFix < ActiveRecord::Migration[5.2]
  def change
    remove_index :forms, :idno
    remove_column :forms, :idno
    add_column :forms, :idno, :jsonb, null: true, array: false, default: {}
    add_index :forms, :idno
  end
end
