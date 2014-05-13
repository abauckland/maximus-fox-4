class CreateDescripts < ActiveRecord::Migration
  def change
    create_table :descripts do |t|
      t.integer :identity_id
      t.integer :product_id

      t.timestamps
    end
  end
end
