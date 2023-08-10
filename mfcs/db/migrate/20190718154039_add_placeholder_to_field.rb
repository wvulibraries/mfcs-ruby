class AddPlaceholderToField < ActiveRecord::Migration[5.2]
  def change
    add_column :fields, :placeholder, :string
  end
end
