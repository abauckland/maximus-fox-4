class CreateIdentvalues < ActiveRecord::Migration
  def change
    create_table :identvalues do |t|
      t.integer :identtxt_id
      t.integer :company_id

      t.timestamps
    end
  end
end
