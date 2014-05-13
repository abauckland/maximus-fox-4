class CreateIdenttxts < ActiveRecord::Migration
  def change
    create_table :identtxts do |t|
      t.string :text

      t.timestamps
    end
  end
end
