class CreateCharcs < ActiveRecord::Migration
  def change
    create_table :charcs do |t|
      t.integer :instance_id
      t.integer :perform_id

      t.timestamps
    end
  end
end
