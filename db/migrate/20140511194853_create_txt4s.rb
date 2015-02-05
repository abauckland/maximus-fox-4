class CreateTxt4s < ActiveRecord::Migration
  def change
    create_table :txt4s do |t|
      t.string :text

      t.timestamps
    end

    add_index :txt4s, :id, name: "id_UNIQUE", unique: true, using: :btree
    add_index :txt4s, :text, name: "text_UNIQUE", unique: true, using: :btree

  end
end
