class CreateSubsectionusers < ActiveRecord::Migration
  def change
    create_table :subsectionusers do |t|
      t.integer :projectuser_id
      t.integer :subsection_id

      t.timestamps
    end
  end
end
