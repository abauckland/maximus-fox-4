class CreateUnits < ActiveRecord::Migration
  def change
    create_table :units do |t|
      t.string :text

      t.timestamps
    end
  end
end
