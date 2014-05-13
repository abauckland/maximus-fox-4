class CreateTxt1s < ActiveRecord::Migration
  def change
    create_table :txt1s do |t|
      t.string :text

      t.timestamps
    end
  end
end
