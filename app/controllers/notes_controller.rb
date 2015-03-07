class NotesController < ApplicationController

  def index
    user = current_user
    destination = user.destinations.find(params[:destination_id])
    notes = destination.notes
    respond_to do |format|
      format.html
      format.json { render json: notes.sort_by { |note| note.created_at } }
    end
  end

  def create
    Note.create note_params
    user = current_user
    @destinations = user.destinations
    respond_to do |format|
      format.html
      format.json { render json: @destinations.last.notes.last }
    end
  end

  def update
    @note = Note.find(params[:id])
    @note.update note_params
    render json: @note
  end

  def destroy
  end

  def note_params
    params.require(:note).permit(
      :title,
      :body,
      :destination_id
    )
  end

end
