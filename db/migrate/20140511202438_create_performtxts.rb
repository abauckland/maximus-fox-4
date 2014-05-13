class CreatePerformtxts < ActiveRecord::Migration
  def change
    create_table :performtxts do |t|
      t.string :text

      t.timestamps
    end
  end
end
