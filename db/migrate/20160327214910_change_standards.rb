class ChangeStandards < ActiveRecord::Migration
  def change
    add_column :standards, :year, :datetime
    add_column :standards, :status, :string
    add_column :standards, :type, :string
  end
end
