class DestinationsController < ApplicationController
  include DestinationHelper

  def index
    @user = User.find(session[:user_id])
    data = retrieve_info_from_google(params[:location]) if params[:location]
    respond_to do |format|
      format.html
      format.json { render json: data }
    end
  end

end
