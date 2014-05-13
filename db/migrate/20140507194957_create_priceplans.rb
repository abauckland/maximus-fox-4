class CreatePriceplans < ActiveRecord::Migration
  def change
    create_table :priceplans do |t|
      t.string :name
      t.string :plan
      t.integer :sign_up

      t.timestamps
    end
  end
end
