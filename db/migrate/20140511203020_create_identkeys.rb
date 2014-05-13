class CreateIdentkeys < ActiveRecord::Migration
  def change
    create_table :identkeys do |t|
      t.string :text

      t.timestamps
    end
  end
end
