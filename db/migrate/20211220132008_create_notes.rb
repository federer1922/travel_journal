class CreateNotes < ActiveRecord::Migration[6.1]
  def change
    create_table :notes do |t|
      t.string :city
      t.text :description
      t.timestamps
    end
    add_reference :notes, :user, null: false, index: true
  end
end
