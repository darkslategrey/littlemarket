# coding: utf-8
class WelcomeController < ApplicationController
  before_filter :login_required
  
  def index
    @title = 'Vos créations'
  end

  
end
