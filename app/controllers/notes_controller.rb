class NotesController < ApplicationController  
  def index 
    @notes = Note.where(user: current_user)
  end

  def create
    if current_user
      note = current_user.notes.build(note_params)
      if note.save
        redirect_to root_path, notice: "Note successfully created" 
      else
        redirect_to root_path, alert: note.errors.full_messages.first 
      end
    else
      redirect_to root_path, alert: "You need to sign in to create a note"
    end
  end

  def edit
    @note = Note.find params["note_id"]
  end

  def update
    note = Note.find params["note_id"]
    if note.update(note_params)
      redirect_to root_path, notice: "Note successfully updated" 
    else
      redirect_to edit_path(note_id: note.id), alert: note.errors.full_messages.first
    end
  end

  def note_params
    params.require(:note).permit(:city, :description)
  end
end