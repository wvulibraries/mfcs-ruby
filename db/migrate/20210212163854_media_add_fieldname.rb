class MediaAddFieldname < ActiveRecord::Migration[6.0]
  def change
    add_column(:media, :fieldname, :string)
  end
end
