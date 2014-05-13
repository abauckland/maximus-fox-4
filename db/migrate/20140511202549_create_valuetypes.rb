class CreateValuetypes < ActiveRecord::Migration
  def change
    create_table :valuetypes do |t|
      t.integer :unit_id
      t.integer :standard_id

      t.timestamps
    end
  end
end
