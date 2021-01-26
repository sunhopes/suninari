class CreateGreactions < ActiveRecord::Migration[5.2]
  def change
    create_table :greactions do |t|
      t.string :rxnid
      t.string :reactant
      t.string :enzyme_name
      t.string :sugar_nt
      t.string :product
      t.string :cellular_locate
      t.references :gpathway, foreign_key: true

      t.timestamps
    end
  end
end
