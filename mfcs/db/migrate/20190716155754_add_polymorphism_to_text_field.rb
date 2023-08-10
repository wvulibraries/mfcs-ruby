class AddPolymorphismToTextField < ActiveRecord::Migration[5.2]
  def change
    add_reference :text_fields, :formable, polymorphic: true, index: true
  end
end
