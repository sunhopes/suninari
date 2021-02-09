class AddOntoidToGreaction < ActiveRecord::Migration[5.2]
  def change
    add_column :greactions, :enzyme_onto_id, :string
    add_column :greactions, :sugar_onto_id, :string
    add_column :greactions, :cellcomp_onto_id, :string
  end
end
