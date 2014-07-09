class CreateClientimages < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.string :name
      t.integer :project_id
      t.string :client_logo

      t.timestamps
    end
  end
end
