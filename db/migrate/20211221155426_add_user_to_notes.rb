class AddUserToNotes < ActiveRecord::Migration[6.1]
  def change
    add_reference :notes, :user, null: false, index: true, foreign_key: true
  end
end
