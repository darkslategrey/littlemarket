

module LittleMarket

  class API < Grape::API

    before do
      :check_lm_connection
    end
    
    resource :creations do
      default_format :json
      
      get '/' do
        LittleMarketCreation.all
      end

    end


    private

    def check_lm_connection
      error! "Not connected" if !LittleMarket::Connection.connected?
    end
  end
end
