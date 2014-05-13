class CreateLinetypes < ActiveRecord::Migration
  def change
    create_table :linetypes do |t|
      t.string :ref
      t.string :description
      t.string :example
      t.integer :txt1
      t.integer :txt2
      t.integer :txt3
      t.integer :txt4
      t.integer :txt5
      t.integer :txt6
      t.integer :identity
      t.integer :perform

      t.timestamps
    end
  end
end
