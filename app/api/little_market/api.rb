# coding: utf-8


module LittleMarket

  class API < Grape::API


    helpers do
      def session
        env[Rack::Session::Abstract::ENV_SESSION_KEY]
      end
    end
    
    before do
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
        if ENV['RAILS_ENV'] == 'development'
          [{:lmid=>15485607, :title=>"Programmes fait maison ", :state=>"published"}, {:lmid=>15485599, :title=>"Programmes fait maison ", :state=>"published"}, {:lmid=>15485593, :title=>"Programmes fait maison ", :state=>"published"}, {:lmid=>15485585, :title=>"Programmes fait maison ", :state=>"published"}, {:lmid=>15485583, :title=>"Programmes fait maison ", :state=>"published"}, {:lmid=>15485579, :title=>"Programmes fait maison ", :state=>"published"}, {:lmid=>15485573, :title=>"Programmes fait maison ", :state=>"published"}, {:lmid=>15485569, :title=>"Programmes fait maison ", :state=>"published"}, {:lmid=>15485567, :title=>"Programmes fait maison ", :state=>"published"}, {:lmid=>15485563, :title=>"Programmes fait maison ", :state=>"published"}, {:lmid=>15485561, :title=>"Programmes fait maison ", :state=>"published"}, {:lmid=>15485185, :title=>"Programmes fait maison ", :state=>"published"}, {:lmid=>15485181, :title=>"Programmes fait maison ", :state=>"published"}]          
        else
          creations = LittleMarketCreation.all
          Rails.logger.debug "Creations size #{creations.size}"
          creations
        end        
      end

      get 'publish' do
        begin
          if false # ENV['RAILS_ENV'] == 'development'
            msg = "Votre creation "
            msg += "à bien été publiée sur LittleMarket"
            { msg: msg, lmid: 12 }
          else
            creation = Creation.find_by_lmid params[:lmid]          
            Rails.logger.debug "Publish crea #{creation.lmid}"
            LittleMarketCreation.publish creation
            msg = "Votre creation '#{creation.title}' (#{creation.lmid}) "
            msg += "à bien été publiée sur LittleMarket"
            { msg: msg, lmid: creation.lmid }
          end
        rescue Exception => e
          msg = "Error : #{e}"
          Rails.logger.error msg + e.backtrace.join("\n")
          error!({ msg: msg, title: creation.title }, 500)
        end
      end

      
      get '/delete' do
        begin
          if ENV['RAILS_ENV'] == 'development'
            msg = "suppression de #{params[:lmid]}"
            { msg: msg, lmid: params[:lmid] }
          else
            Rails.logger.debug "Delete crea #{params[:lmid]}"
            LittleMarketCreation.delete params[:lmid]
            creation = Creation.find_by_lmid params[:lmid]
            msg = "Votre creation '#{creation.title}' (#{params[:lmid]}} "
            msg += "à bien été supprimée de LittleMarket"
          end
        rescue Exception => e
          msg = "Error : #{e}"
          Rails.logger.error msg + e.backtrace.join("\n")
          error!({ msg: msg, title: params[:title] }, 500)
        end
        { msg: msg, title: params[:title] }
      end
    end
  end
end
