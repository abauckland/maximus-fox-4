class CreateCharcs < ActiveRecord::Migration
  def change
    create_table :charcs do |t|
      t.integer :instance_id
      t.integer :perform_id

      t.timestamps
    end

    add_index :charcs, :instance_id, name: "INSTANCE", using: :btree
    add_index :charcs, :perform_id, name: "PERFORM", using: :btree

  end
end
