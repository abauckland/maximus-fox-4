class CreatePerforms < ActiveRecord::Migration
  def change
    create_table :performs do |t|
      t.integer :performskey_id
      t.integer :performvalue_id

      t.timestamps
    end

    add_index :performs, :performkey_id, name: "PERFORMKEY", using: :btree

  end
end
