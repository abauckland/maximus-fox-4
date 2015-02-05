class CreateDescripts < ActiveRecord::Migration
  def change
    create_table :descripts do |t|
      t.integer :identity_id
      t.integer :product_id

      t.timestamps
    end

    add_index :descripts, :identity_id, name: "IDENTITY", using: :btree
    add_index :descripts, :product_id, name: "PRODUCT", using: :btree

  end
end
