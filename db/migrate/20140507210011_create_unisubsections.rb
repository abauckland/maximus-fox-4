class CreateUnisubsections < ActiveRecord::Migration
  def change
    create_table :unisubsections do |t|
      t.integer :ref
      t.string :text
      t.integer :unisection_id
      t.integer :guidepdf_id

      t.timestamps
    end
  end
end
