class CreateTxt6s < ActiveRecord::Migration
  def change
    create_table :txt6s do |t|
      t.string :text

      t.timestamps
    end

    add_index :txt6s, :id, name: "id_UNIQUE", unique: true, using: :btree
    add_index :txt6s, :text, name: "text_UNIQUE", unique: true, using: :btree

  end
end
