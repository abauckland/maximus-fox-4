class CreateTxt5s < ActiveRecord::Migration
  def change
    create_table :txt5s do |t|
      t.string :text

      t.timestamps
    end
  end
end
