class CreateClauseguides < ActiveRecord::Migration
  def change
    create_table :clauseguides do |t|
      t.integer :clause_id
      t.integer :guidenote_id
      t.integer :plan_id
      t.timestamps
    end
  end
end
