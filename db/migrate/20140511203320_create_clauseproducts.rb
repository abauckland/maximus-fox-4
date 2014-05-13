class CreateClauseproducts < ActiveRecord::Migration
  def change
    create_table :clauseproducts do |t|
      t.integer :clause_id
      t.integer :product_id

      t.timestamps
    end
  end
end
