class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :company_id
      t.string :first_name
      t.string :surname
      t.integer :role
      t.string :ip
      t.string :api_key
      t.string :state
      t.integer :active
      t.timestamps
    end
  end
end
