class CreateShoppingCarts < ActiveRecord::Migration[6.0]
  def change
    create_table :shopping_carts do |t|
      t.integer :cid
      t.string :items

      t.timestamps
    end
  end
end
