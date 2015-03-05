class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    @user.save
    redirect_to "/"
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    user = User.find(params[:id])
    user.update user_params
    redirect_to destinations_path
  end

  def user_params
    params.require(:user).permit(
      :fname,
      :lname,
      :email,
      :password,
      :password_confirmation
    )
  end

end
