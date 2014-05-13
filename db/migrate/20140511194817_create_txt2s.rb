class CreateTxt2s < ActiveRecord::Migration
  def change
    create_table :txt2s do |t|
      t.string :text

      t.timestamps
    end
  end
end
