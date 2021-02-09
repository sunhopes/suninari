class AddColumnToGreaction < ActiveRecord::Migration[5.2]
  def change
    add_reference :greactions, :sugar, foreign_key: true
  end
end
