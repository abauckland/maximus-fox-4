class CreateSpeclines < ActiveRecord::Migration
  def change
    create_table :speclines do |t|
      t.integer :project_id
      t.integer :clause_id
      t.integer :clause_line
      t.integer :txt1_id
      t.integer :txt2_id
      t.integer :txt3_id
      t.integer :txt4_id
      t.integer :txt5_id
      t.integer :txt6_id
      t.integer :identity_id
      t.integer :perform_id
      t.integer :linetype_id

      t.timestamps
    end
  end
end
