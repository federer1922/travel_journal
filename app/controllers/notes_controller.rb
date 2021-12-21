class NotesController < ApplicationController  
  def index 
    @notes = Note.where(user: current_user)
  end

  def create
    note = current_user.notes.build(create_note_params)
    if note.valid?
      weather = OpenweathermapService.call(note.city)
      if weather[:success]
        note.temperature = weather[:temperature]
        note.wind = weather[:wind]
        note.clouds = weather[:clouds]
        note.save
        redirect_to root_path, notice: "Note successfully created" 
      else
        http_status = weather[:http_status]
        alert = weather[:alert]
        redirect_to root_path, alert: "#{ http_status }, #{ alert }, enter valid city name"
      end
    else
      redirect_to root_path, alert: note.errors.full_messages.first 
    end
  end

  def edit
    @note = Note.find params["note_id"]
  end

  def update
    note = Note.find params["note_id"]
    if note.update(update_note_params)
      redirect_to root_path, notice: "Note successfully updated" 
    else
      redirect_to edit_path(note_id: note.id), alert: note.errors.full_messages.first
    end
  end

  def destroy
    note = Note.find params["note_id"]
    note.destroy!

    redirect_to root_path, notice: "Note successfully deleted"
  end

  def create_note_params
    params.require(:note).permit(:city, :description)
  end

  def update_note_params
    params.require(:note).permit(:description)
  end
end