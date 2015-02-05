class CreateSubsections < ActiveRecord::Migration
  def change
    create_table :subsections do |t|
      t.integer :cawssubsection_id
      t.integer :unisubsection_id

      t.timestamps
    end

    add_index :subsections, :cawssubsection_id, name: "CAWS", using: :btree
    add_index :subsections, :unisubsection_id, name: "UNI", using: :btree

  end
end
