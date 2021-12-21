class AddColumnsToNotes < ActiveRecord::Migration[6.1]
  def change
    add_column :notes, :temperature, :decimal, precision: 5, scale: 2, default: 0
    add_column :notes, :wind, :decimal, precision: 5, scale: 2, default: 0
    add_column :notes, :clouds, :integer
  end
end
