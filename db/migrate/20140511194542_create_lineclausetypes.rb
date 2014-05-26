class CreateLineclausetypes < ActiveRecord::Migration
  def change
    create_table :lineclausetypes do |t|
      t.integer :clausetype_id
      t.integer :linetype_id

      t.timestamps
    end
  end
end
