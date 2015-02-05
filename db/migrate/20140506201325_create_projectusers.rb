class CreateProjectusers < ActiveRecord::Migration
  def change
    create_table :projectusers do |t|
      t.integer :user_id
      t.integer :project_id
      t.integer :role
      
      t.timestamps
    end

    add_index :projectusers, :user_id, name: "USER", using: :btree
    add_index :projectusers, :project_id, name: "PROJECT", using: :btree

  end
end
