class DestinationsController < ApplicationController
  include DestinationHelper

  def index
    @user = User.find(session[:user_id])
    @destinations = User.find(session[:user_id]).destinations
    data = retrieve_info_from_google(params[:location]) if params[:location]
    respond_to do |format|
      format.html
      format.json { render json: data }
    end
  end

  def create
    params = destination_params
    params[:user_id] = session[:user_id]

    if !Destination.find_by(location: params[:location], user_id: session[:user_id])
      Destination.create! params
    end
    @destinations = User.find(session[:user_id]).destinations
    render json: @destinations

  end

  def destroy
    Destination.find(params[:id]).delete
    head :no_content
  end

  def destination_params
    params.require(:destination).permit(:location)
  end

end
