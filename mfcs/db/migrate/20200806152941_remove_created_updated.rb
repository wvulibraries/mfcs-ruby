class RemoveCreatedUpdated < ActiveRecord::Migration[6.0]
  def change
    remove_column :items, :created_by, :integer
    remove_column :items, :modified_by, :integer
  end
end
