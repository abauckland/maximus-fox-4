class CreateInstances < ActiveRecord::Migration
  def change
    create_table :instances do |t|
      t.integer :product_id
      t.string :code

      t.timestamps
    end

    add_index :instances, :product_id, name: "PRODUCT", using: :btree

  end
end
