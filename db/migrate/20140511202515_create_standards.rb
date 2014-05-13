class CreateStandards < ActiveRecord::Migration
  def change
    create_table :standards do |t|
      t.string :ref
      t.string :title

      t.timestamps
    end
  end
end
