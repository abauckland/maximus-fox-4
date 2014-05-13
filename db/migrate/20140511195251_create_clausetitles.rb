class CreateClausetitles < ActiveRecord::Migration
  def change
    create_table :clausetitles do |t|
      t.string :text

      t.timestamps
    end
  end
end
