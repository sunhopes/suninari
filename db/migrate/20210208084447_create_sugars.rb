class CreateSugars < ActiveRecord::Migration[5.2]
  def change
    create_table :sugars do |t|
      t.string :onto_id
      t.string :name

      t.timestamps
    end
  end
end
