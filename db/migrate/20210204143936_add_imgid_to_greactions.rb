class AddImgidToGreactions < ActiveRecord::Migration[5.2]
  def change
    add_column :greactions, :reactant_img, :string
    add_column :greactions, :product_img, :string
  end
end
