class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.integer :tel
      t.string :www
      t.string :reg_address
      t.integer :reg_number
      t.string :reg_name
      t.string :reg_location
      t.integer :read_term
      t.integer :category
      t.string :logo
      t.integer :no_licence

      t.timestamps
    end
  end
end
