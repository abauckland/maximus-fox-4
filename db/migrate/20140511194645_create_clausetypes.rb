class CreateClausetypes < ActiveRecord::Migration
  def change
    create_table :clausetypes do |t|
      t.string :text

      t.timestamps
    end
  end
end
