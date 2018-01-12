class CreateTxt5s < ActiveRecord::Migration
  def change
    create_table :txt5s do |t|
      t.string :text

      t.timestamps
    end

    add_index :txt5s, :id, name: "id_UNIQUE", unique: true, using: :btree
    add_index :txt5s, :text, name: "text_UNIQUE", unique: true, using: :btree

  end
end
