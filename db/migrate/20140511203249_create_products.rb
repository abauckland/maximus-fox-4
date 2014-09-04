class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.integer :producttype_id

      t.timestamps
    end
  end
end
