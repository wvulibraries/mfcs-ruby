class AddPositionPlaceholderToTextField < ActiveRecord::Migration[5.2]
  def change
    add_column :text_fields, :position, :integer
    add_column :text_fields, :placeholder, :string
  end
end
