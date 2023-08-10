class AddTimestampsToFields < ActiveRecord::Migration[5.2]
  def change
    add_column :text_fields, :created_at, :datetime, null: false
    add_column :text_fields, :updated_at, :datetime, null: false
    add_column :idno_fields, :created_at, :datetime, null: false
    add_column :idno_fields, :updated_at, :datetime, null: false
    add_column :fields, :created_at, :datetime, null: false
    add_column :fields, :updated_at, :datetime, null: false
  end
end
