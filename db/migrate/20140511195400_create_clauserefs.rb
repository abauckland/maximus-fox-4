class CreateClauserefs < ActiveRecord::Migration
  def change
    create_table :clauserefs do |t|
      t.integer :clausetype_id
      t.integer :clause_no
      t.integer :subclause
      t.integer :subsection_id

      t.timestamps
    end

    add_index :clauserefs, [:subsection_id], name: "SUBSECTION", using: :btree
    add_index :clauserefs, [:clausetype_id], name: "CLAUSETYPE", using: :btree
    add_index :clauserefs, [:subsection_id, :clausetype_id], name: "SUBECTION_CLAUSETYPE", using: :btree

  end
end
