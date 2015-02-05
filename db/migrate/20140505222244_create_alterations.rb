class CreateAlterations < ActiveRecord::Migration
  def changa
    create_table :alterations do |t|
      t.integer :specline_id
      t.integer :project_id
      t.integer :clause_id
      t.integer :txt1_id
      t.integer :txt2_id
      t.integer :txt3_id
      t.integer :txt4_id
      t.integer :txt5_id
      t.integer :txt6_id
      t.integer :identity_id
      t.integer :perform_id
      t.integer :linetype_id
      t.string :event
      t.integer :clause_add_delete
      t.integer :revision_id
      t.integer :print_change
      t.integer :user_id

      t.timestamps
    end

    add_index :alterations, [:revision_id, :project_id], name: "PROJECT", using: :btree
    add_index :alterations, [:revision_id, :project_id, :event, :clause_id], name: "CLAUSE", using: :btree

  end
end
