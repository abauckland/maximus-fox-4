class CreateStandardkeys < ActiveRecord::Migration
  def change
    create_table :standardkeys do |t|
      t.integer :standard_id
      t.integer :performkey_id
      t.string :type
      t.string :verification
      t.timestamps
    end
  end
end
