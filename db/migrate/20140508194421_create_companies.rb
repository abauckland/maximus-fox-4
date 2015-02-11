class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.string :tel
      t.string :www
      t.string :reg_address
      t.string :reg_number
      t.string :reg_name
      t.string :reg_location
      t.integer :read_term
      t.integer :category
      t.string :logo
      t.integer :no_licence

      t.timestamps
    end

    add_index :companies, :name, name: "COMPANY_NAME", using: :btree

  end
end
