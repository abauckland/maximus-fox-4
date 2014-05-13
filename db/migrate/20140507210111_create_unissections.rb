class CreateUnissections < ActiveRecord::Migration
  def change
    create_table :unissections do |t|
      t.string :ref
      t.string :text

      t.timestamps
    end
  end
end
