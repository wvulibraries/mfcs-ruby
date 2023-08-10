class ChangeIndexHstores < ActiveRecord::Migration[5.2]
  def change
    remove_index :forms, :fields
    remove_index :forms, :navigation
    add_index :forms, :fields, using: :gist
    add_index :forms, :navigation, using: :gist
    add_index :forms, :idno, using: :gist
    add_index :forms, :permissions, using: :gist
  end
end
