class DestinationsController < ApplicationController
  include DestinationHelper

  def index
    @user = User.find(session[:user_id])
    geodata = find_latitude_and_longitude(params[:location]) if params[:location]
    respond_to do |format|
      format.html
      format.json { render json: geodata }
    end
  end



end
