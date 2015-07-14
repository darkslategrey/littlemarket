# coding: utf-8
class UserController < ApplicationController


  def login
    @user = User.new
    @user.username = params[:username]

  end

  def register
    @user = User.new
    @user.username = params[:username]
  end

  def process_registration
    begin
      @user = User.create user_params
      raise if @user.errors.any?
      session[:id] = @user.id
      redirect_to '/'      
    rescue Exception => e
      flash[:error] = "Problème lors de votre enregistrement : #{e}"
      render :register
    end
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


  private

  def user_params
    params.require(:user).permit!
  end
  
end
