class CreatePrints < ActiveRecord::Migration
  def change
    create_table :prints do |t|
      t.integer :project_id
      t.integer :revision_id
      t.integer :user_id
      t.string :issued

      t.timestamps
    end
  end
end
