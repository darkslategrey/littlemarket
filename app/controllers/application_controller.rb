

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  before_filter :init_browser, :set_user
  
  protect_from_forgery with: :exception


  protected

  def connect_default
    if !LittleMarket::Connection.connected?
      user = User.first
      BROWSER.login({ username: user.username, password: user.password }) unless
        ENV['RAILS_ENV'] == 'test'
      session[:id] = user.id
    end
  end
  
  def set_user
    @user = User.find(session[:id]) if @user.nil? && session[:id]
  end

  def login_required
    return true if @user
    access_denied
    return false

  end

  def access_denied
    session[:return_to] = request.fullpath
    flash[:error] = "Oops. You need to login before you can view that page : '#{request.fullpath}'"
    redirect_to :controller => 'user', :action => 'login'
  end
  
  private
  
  def init_browser
    @browser = BROWSER
  end

end
