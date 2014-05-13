class CreateClauses < ActiveRecord::Migration
  def change
    create_table :clauses do |t|
      t.integer :clauseref_id
      t.integer :clausetitle_id
      t.integer :guidenote_id
      t.integer :project_id

      t.timestamps
    end
  end
end
