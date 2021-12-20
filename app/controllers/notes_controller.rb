class NotesController < ApplicationController  
  def index 
    @notes = Note.where(user: current_user)
  end
end