class CreatePerformvalues < ActiveRecord::Migration
  def change
    create_table :performvalues do |t|
      t.integer :valuetype_id
      t.integer :performtxt_id

      t.timestamps
    end
  end
end
