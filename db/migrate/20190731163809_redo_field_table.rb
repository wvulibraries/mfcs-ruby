class RedoFieldTable < ActiveRecord::Migration[5.2]
  def change
    # remove the table
    drop_table :fields
    # create the table
    create_table :fields do |t|
      t.belongs_to :field_types, polymorphic: true
      t.belongs_to :form
    end
  end
end
