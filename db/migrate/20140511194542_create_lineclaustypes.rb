class CreateLineclaustypes < ActiveRecord::Migration
  def change
    create_table :lineclaustypes do |t|
      t.integer :clausetype_id
      t.integer :linetype_id

      t.timestamps
    end
  end
end
