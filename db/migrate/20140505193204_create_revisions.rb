class CreateRevisions < ActiveRecord::Migration
  def change
    create_table :revisions do |t|
      t.string :rev
      t.string :project_status
      t.integer :project_id
      t.integer :user_id
      t.timestamp :date

      t.timestamps
    end

    add_index :revisions, :project_id, name: "PROJECT", using: :btree

  end
end
