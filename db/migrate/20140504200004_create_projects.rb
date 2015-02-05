class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :code
      t.string :title
      t.integer :parent_id
      t.integer :company_id
      t.integer :project_status
      t.integer :ref_system
      t.string :image
      t.string :project_image
      t.string :client_logo
      t.string :client_name

      t.timestamps
    end

    add_index :projects, :company_id, name: "COMPANY", using: :btree

  end
end
