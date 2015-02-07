class CreateHelps < ActiveRecord::Migration
  def change
    create_table :helps do |t|
      t.string :item
      t.text :text

      t.timestamps
    end
  end
end
