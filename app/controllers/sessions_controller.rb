class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.find_by_email(params[:email])

    if @user && @user.authenitcate(params[:password])
      session[:user_id] = @user.id
      redirect_to root_path
    else
      redirect_to login_path, notice: 'Email/Password incorrect.'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path
  end
end