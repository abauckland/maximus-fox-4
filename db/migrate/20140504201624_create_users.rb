class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :company_id
      t.string :first_name
      t.string :surname
      t.string :email
      t.integer :role
      t.string :api_key
      t.string :password_hash
      t.string :password_salt
      t.string :password_reset_token
      t.timestamp :password_reset_sent_at

      t.timestamps
    end
  end
end
