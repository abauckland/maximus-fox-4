class CreateClientimages < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name
      t.integer :project_id
      t.string :photo_file_name
      t.string :photo_content_type
      t.string :photo_file_size
      t.string :photo_updated_at

      t.timestamps
    end
  end
end
