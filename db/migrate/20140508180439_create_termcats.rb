class CreateTermcats < ActiveRecord::Migration
  def change
    create_table :termcats do |t|
      t.string :text

      t.timestamps
    end
  end
end
