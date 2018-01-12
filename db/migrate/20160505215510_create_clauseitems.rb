class CreateClauseitems < ActiveRecord::Migration
  def change
    create_table :clauseitems do |t|
      t.integer :clause_id, :unique => true
      t.integer :item_id
      t.timestamps
    end

    add_index :clauseitems, :clause_id, name: "CLAUSE", using: :btree
    add_index :clauseitems, :item_id, name: "ITEM", using: :btree

  end
end
