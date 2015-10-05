class CreateRefsystems < ActiveRecord::Migration
  def change
    create_table :refsystems do |t|
      t.integer :name
      t.integer :subsection
      t.integer :section
      t.integer :group
      t.timestamps
    end
  end
end
