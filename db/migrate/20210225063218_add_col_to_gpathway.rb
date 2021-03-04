class AddColToGpathway < ActiveRecord::Migration[5.2]
  def change
    add_column :gpathways, :pw_category, :string
    add_column :gpathways, :pw_category_id, :string
    add_column :gpathways, :species_id, :string
    add_column :gpathways, :tissue_id, :string
    add_column :gpathways, :cell_line_id, :string
  end
end
