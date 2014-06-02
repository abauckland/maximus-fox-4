class CreateSubsections < ActiveRecord::Migration
  def change
    create_table :subsections do |t|
      t.integer :cawssubsection_id
      t.integer :unisubsection_id

      t.timestamps
    end
  end
end
