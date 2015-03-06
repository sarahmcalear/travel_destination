class NotesController < ApplicationController

  def create
    Note.create note_params
    @notes = User.find(session[:user_id]).destinations
    respond_to do |format|
      format.html
      format.json { render json: @notes.last.notes.last }
    end
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
