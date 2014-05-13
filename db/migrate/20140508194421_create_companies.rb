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
      t.string :photo_file_name
      t.string :photo_content_type
      t.string :photo_file_size
      t.string :photo_updated_at
      t.integer :no_licence

      t.timestamps
    end
  end
end
