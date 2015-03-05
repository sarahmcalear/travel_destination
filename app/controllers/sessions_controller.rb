class SessionsController < ApplicationController

  def new
  end

  def create
    $message = nil
    user = User.find_by({email: params[:email]})
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to destinations_path
    else
      $message = "Your username or password was incorrect. Please register if you do not have a login."
      redirect_to "/"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to "/"
  end

end
