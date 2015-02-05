class CreateClauses < ActiveRecord::Migration
  def change
    create_table :clauses do |t|
      t.integer :clauseref_id
      t.integer :clausetitle_id
      t.integer :guidenote_id
      t.integer :project_id

      t.timestamps
    end

    add_index :clauses, [:project_id], name: "PROJECT", using: :btree
    add_index :clauses, [:clauseref_id], name: "CLAUSEREF", using: :btree

  end
end
