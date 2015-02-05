class CreateSubsectionusers < ActiveRecord::Migration
  def change
    create_table :subsectionusers do |t|
      t.integer :projectuser_id
      t.integer :subsection_id

      t.timestamps
    end

    add_index :subsectionusers, :projectuser_id, name: "PROJECT", using: :btree
    add_index :subsectionusers, :subsection_id, name: "SUBSECTION", using: :btree

  end
end
