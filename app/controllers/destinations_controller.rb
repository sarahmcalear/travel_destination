class DestinationsController < ApplicationController
  include DestinationHelper
  include ApplicationHelper

  before_action :authenticate

  def index
    @user = User.find(session[:user_id])
    @note = Note.new
    @destinations = User.find(session[:user_id]).destinations
    desired_destination = params[:location] ? params[:location] : choose_random_destination.sample
    google_data    = retrieve_info_from_google(desired_destination)
    panoramio_pics = retrieve_panoramio_photos(desired_destination)
    # weather = retrieve_weather_from_wunderground(desired_destination)
    # TODO: optimize this for speed.
    # wolfram_data = retrieve_info_from_wolfram(desired_destination)
    respond_to do |format|
      format.html
      format.json { render json: {google_data: google_data, panoramio_pics: panoramio_pics, searchLocation: desired_destination} }
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
