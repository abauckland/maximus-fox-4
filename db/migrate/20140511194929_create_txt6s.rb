class CreateTxt6s < ActiveRecord::Migration
  def change
    create_table :txt6s do |t|
      t.string :text

      t.timestamps
    end
  end
end
