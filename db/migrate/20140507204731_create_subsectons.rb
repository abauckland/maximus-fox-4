class CreateSubsectons < ActiveRecord::Migration
  def change
    create_table :subsectons do |t|
      t.integer :cawssubsection_id
      t.integer :unisubsection_id

      t.timestamps
    end
  end
end
