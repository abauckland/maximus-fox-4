class ChangeProjects < ActiveRecord::Migration
  def change
    add_column :projects, :refsystem_id, :string
    add_column :projects, :printsetting_id, :string
  end
end
