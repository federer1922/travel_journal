class RemoveUserFromNotes < ActiveRecord::Migration[6.1]
  def change
    remove_reference :notes, :user, null: false, index: true
  end
end
