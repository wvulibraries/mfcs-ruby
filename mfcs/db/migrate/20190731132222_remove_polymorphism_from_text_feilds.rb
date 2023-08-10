class RemovePolymorphismFromTextFeilds < ActiveRecord::Migration[5.2]
  def change
    remove_reference :text_fields, :formable, polymorphic: true, index: true
    remove_reference :fields, :formable, polymorphic: true, index: true
  end
end
