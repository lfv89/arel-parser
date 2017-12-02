class AddSlugToSegments < ActiveRecord::Migration[5.1]
  def change
    add_column :segments, :slug, :string
  end
end
