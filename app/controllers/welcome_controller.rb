class WelcomeController < ApplicationController
  before_filter :login_required
  
  def index

    @creations = LittleMarket::Utils.get_creations
                  
  end

  
end
