class CreateTerms < ActiveRecord::Migration
  def change
    create_table :terms do |t|
      t.integer :termcat_id
      t.text :text

      t.timestamps
    end
  end
end
