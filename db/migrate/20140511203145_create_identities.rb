class CreateIdentities < ActiveRecord::Migration
  def change
    create_table :identities do |t|
      t.integer :identkey_id
      t.integer :identvalue_id

      t.timestamps
    end
  end
end
