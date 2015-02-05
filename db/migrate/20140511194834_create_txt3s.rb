class CreateTxt3s < ActiveRecord::Migration
  def change
    create_table :txt3s do |t|
      t.string :text

      t.timestamps
    end

    add_index :txt3s, :id, name: "id_UNIQUE", unique: true, using: :btree
    add_index :txt3s, :text, name: "text_UNIQUE", unique: true, using: :btree

  end
end
