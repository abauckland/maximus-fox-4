class CreateClauseproducts < ActiveRecord::Migration
  def change
    create_table :clauseproducts do |t|
      t.integer :clause_id
      t.integer :product_id

      t.timestamps
    end

    add_index :clauseproducts, :clause_id, name: "CLAUSE", using: :btree
    add_index :clauseproducts, :product_id, name: "PRODUCT", using: :btree

  end
end
