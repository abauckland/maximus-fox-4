class CreateFeatures < ActiveRecord::Migration
  def change
    create_table :features do |t|
      t.string :title
      t.string :text
      t.string :image

      t.timestamps
    end
  end
end
