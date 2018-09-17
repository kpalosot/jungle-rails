class SessionsController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.find_by_email(params['user']['email'])

    # email = params['user']['email']
    # password = params['user']['password'] 
    # @user = User.authenticate_with_credentials(email, password)
    if @user && @user.authenticate(params['user']['password'])
      session[:user_id] = @user.id
      redirect_to root_path, notice: 'Logged in'
    else
      redirect_to login_path, notice: 'Email/Password incorrect.'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path
  end
end