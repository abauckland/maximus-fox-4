class CreateIdentities < ActiveRecord::Migration
  def change
    create_table :identities do |t|
      t.integer :identkey_id
      t.integer :identvalue_id

      t.timestamps
    end

    add_index :identities, :identkey_id, name: "KEY", using: :btree
    add_index :identities, :identvalue_id, name: "VALUE", using: :btree

  end
end
