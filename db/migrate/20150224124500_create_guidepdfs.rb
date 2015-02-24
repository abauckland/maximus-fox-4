class CreateGuidepdfs < ActiveRecord::Migration
  def change
    create_table :guidepdfs do |t|
      t.integer :title
      t.integer :guide

      t.timestamps
    end
  end
end
