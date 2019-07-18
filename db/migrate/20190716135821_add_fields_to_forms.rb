class AddFieldsToForms < ActiveRecord::Migration[5.2]
  def change
    add_reference :fields, :formable, polymorphic: true, index: true
  end
end
