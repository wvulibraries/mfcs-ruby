class AddCreatedByToItems < ActiveRecord::Migration[6.1]
  def change
    add_column :items, :created_by, :integer
  end
end
