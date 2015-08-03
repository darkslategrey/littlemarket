# coding: utf-8
class WelcomeController < ApplicationController
  before_filter :connect_default
  # before_filter :login_required
  
  def index
    @title = 'Vos créations'
  end

  
end
