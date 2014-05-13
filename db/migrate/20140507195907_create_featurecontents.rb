class CreateFeaturecontents < ActiveRecord::Migration
  def change
    create_table :featurecontents do |t|
      t.integer :feature_id
      t.string :order
      t.string :title
      t.text :text
      t.string :image

      t.timestamps
    end
  end
end
