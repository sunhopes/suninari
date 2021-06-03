class AddDiseaseToGpathway < ActiveRecord::Migration[5.2]
  def change
    add_column :gpathways, :disease, :string
    add_column :gpathways, :disease_id, :string
  end
end
