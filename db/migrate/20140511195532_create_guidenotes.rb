class CreateGuidenotes < ActiveRecord::Migration
  def change
    create_table :guidenotes do |t|
      t.text :text

      t.timestamps
    end
  end
end
