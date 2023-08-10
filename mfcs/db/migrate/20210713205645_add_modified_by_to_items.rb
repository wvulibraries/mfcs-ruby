class AddModifiedByToItems < ActiveRecord::Migration[6.1]
  def change
    add_column :items, :modified_by, :integer
  end
end
