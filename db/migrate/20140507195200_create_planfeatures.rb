class CreatePlanfeatures < ActiveRecord::Migration
  def change
    create_table :planfeatures do |t|
      t.integer :priceplan_id
      t.string :text

      t.timestamps
    end
  end
end
