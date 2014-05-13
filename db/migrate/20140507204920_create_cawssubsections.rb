class CreateCawssubsections < ActiveRecord::Migration
  def change
    create_table :cawssubsections do |t|
      t.integer :cawssection_id
      t.integer :ref
      t.string :text
      t.integer :guidepdf_id

      t.timestamps
    end
  end
end
