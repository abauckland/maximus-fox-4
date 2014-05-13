class CreateCawssections < ActiveRecord::Migration
  def change
    create_table :cawssections do |t|
      t.string :ref
      t.string :text

      t.timestamps
    end
  end
end
