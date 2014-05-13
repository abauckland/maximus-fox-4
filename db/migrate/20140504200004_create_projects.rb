class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :code
      t.string :title
      t.integer :parent_id
      t.integer :company_id
      t.integer :project_status
      t.integer :rev_method
      t.string :logo_path
      t.integer :ref_system
      t.string :photo_file_name
      t.string :photo_content_type
      t.integer :photo_file_size
      t.timestamp :photo_updated_at

      t.timestamps
    end
  end
end
