

module LittleMarket

  class API < Grape::API


    helpers do
      def session
        env[Rack::Session::Abstract::ENV_SESSION_KEY]
      end
    end
    
    before do
      Rails.logger.debug env.keys
      if !LittleMarket::Connection.connected?
        if !session[:id]
          Rails.logger.debug "NOT Connected !"
          redirect '/'
        else
          user_id = session[:id]
          Rails.logger.debug "session : #{session[:id]}"
          user    = User.find(user_id)
          BROWSER.login({ username: user.username, password: user.password })
        end
      else
        Rails.logger.debug "Connected !"
      end
    end
    
    resource :creations do
      default_format :json
      
      get '/' do
        LittleMarketCreation.all
      end

    end

  end
end
