class CreatePerforms < ActiveRecord::Migration
  def change
    create_table :performs do |t|
      t.integer :performskey_id
      t.integer :performvalue_id

      t.timestamps
    end
  end
end
