class AddTypeToFields < ActiveRecord::Migration[5.2]
  def change
    add_column :fields, :type, :string
  end
end
