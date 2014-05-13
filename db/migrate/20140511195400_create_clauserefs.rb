class CreateClauserefs < ActiveRecord::Migration
  def change
    create_table :clauserefs do |t|
      t.integer :clausetype_id
      t.integer :clause
      t.integer :subclause
      t.integer :subsection_id

      t.timestamps
    end
  end
end
