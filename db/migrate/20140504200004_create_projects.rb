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

      t.timestamps
    end
  end
end
