class CreateProjectusers < ActiveRecord::Migration
  def change
    create_table :projectusers do |t|
      t.integer :user_id
      t.integer :project_id
      t.integer :role
      
      t.timestamps
    end
  end
end
