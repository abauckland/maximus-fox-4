class CreateIdentvalues < ActiveRecord::Migration
  def change
    create_table :identvalues do |t|
      t.integer :identtxt_id
      t.integer :company_id

      t.timestamps
    end

    add_index :identvalues, :company_id, name: "COMPANY", using: :btree
    add_index :identvalues, :identtxt_id, name: "TEXT", using: :btree

  end
end
