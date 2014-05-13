class CreateTxt4s < ActiveRecord::Migration
  def change
    create_table :txt4s do |t|
      t.string :text

      t.timestamps
    end
  end
end
