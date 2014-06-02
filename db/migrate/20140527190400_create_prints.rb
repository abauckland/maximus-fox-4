class CreatePrints < ActiveRecord::Migration
  def change
    create_table :prints do |t|
      t.integer :project_id
      t.integer :revision_id
      t.integer :user_id
      t.string :attachment_file_name
      t.string :attachment_content_type
      t.string :attachment_file_size
      t.string :attachment_updated_at

      t.timestamps
    end
  end
end
