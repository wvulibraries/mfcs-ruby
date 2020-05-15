class FixFormBooleans < ActiveRecord::Migration[6.0]
  def change
    change_column :forms, :metadata, :boolean, default: false, null: false
  end
end
