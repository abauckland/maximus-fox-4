class CreateSpeclines < ActiveRecord::Migration
  def change
    create_table :speclines do |t|
      t.integer :project_id
      t.integer :clause_id
      t.integer :clause_line
      t.integer :txt1_id, :default => 1
      t.integer :txt2_id, :default => 1
      t.integer :txt3_id, :default => 1
      t.integer :txt4_id, :default => 1
      t.integer :txt5_id, :default => 1
      t.integer :txt6_id, :default => 1
      t.integer :identity_id, :default => 1
      t.integer :perform_id, :default => 1
      t.integer :linetype_id

      t.timestamps
    end

    add_index :speclines, :id, name: "id_UNIQUE", unique: true, using: :btree
    add_index :speclines, [:project_id, :clause_id], name: "SPEC", using: :btree

  end
end
