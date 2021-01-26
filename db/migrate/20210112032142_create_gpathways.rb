class CreateGpathways < ActiveRecord::Migration[5.2]
  def change
    create_table :gpathways do |t|
      t.string :title
      t.text :description
      t.string :species
      t.string :tissue
      t.string :cell_line
      t.string :bind_backbone
      t.integer :user_id

      t.timestamps
    end
  end
end
