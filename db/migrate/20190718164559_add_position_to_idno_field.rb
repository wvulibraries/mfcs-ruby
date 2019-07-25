class AddPositionToIdnoField < ActiveRecord::Migration[5.2]
  def change
    add_column :idno_fields, :position, :integer
  end
end
