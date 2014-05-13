class CreatePerformkeys < ActiveRecord::Migration
  def change
    create_table :performkeys do |t|
      t.string :text

      t.timestamps
    end
  end
end
