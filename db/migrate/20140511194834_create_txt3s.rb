class CreateTxt3s < ActiveRecord::Migration
  def change
    create_table :txt3s do |t|
      t.string :text

      t.timestamps
    end
  end
end
