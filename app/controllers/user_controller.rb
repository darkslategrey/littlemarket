class UserController < ApplicationController


  def login
    @user = User.new
    @user.username = params[:username]

  end

  def process_login
    if user = User.authenticate(params[:user])
      session[:id] = user.id
      redirect_to session[:return_to] || '/'
    else
      flash[:error] = 'Invalid login.'
      redirect_to :action => 'login', :username => params[:user][:username]
    end

  end

  def logout
    reset_session
    flash[:message] = 'Logged out.'
    redirect_to :action => 'login'

  end

  def my_account
  end

  
end
