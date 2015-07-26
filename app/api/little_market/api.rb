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
          creations = LittleMarketCreation.all
          Rails.logger.debug "Creations size #{creations.size}"
          creations
        end
        # { [] }
      end

        
      #     [{:lm_id=>15485607, :title=>"Programmes fait maison ", :state=>"published"}, {:lm_id=>15485599, :title=>"Programmes fait maison ", :state=>"published"}, {:lm_id=>15485593, :title=>"Programmes fait maison ", :state=>"published"}, {:lm_id=>15485585, :title=>"Programmes fait maison ", :state=>"published"}, {:lm_id=>15485583, :title=>"Programmes fait maison ", :state=>"published"}, {:lm_id=>15485579, :title=>"Programmes fait maison ", :state=>"published"}, {:lm_id=>15485573, :title=>"Programmes fait maison ", :state=>"published"}, {:lm_id=>15485569, :title=>"Programmes fait maison ", :state=>"published"}, {:lm_id=>15485567, :title=>"Programmes fait maison ", :state=>"published"}, {:lm_id=>15485563, :title=>"Programmes fait maison ", :state=>"published"}, {:lm_id=>15485561, :title=>"Programmes fait maison ", :state=>"published"}, {:lm_id=>15485185, :title=>"Programmes fait maison ", :state=>"published"}, {:lm_id=>15485181, :title=>"Programmes fait maison ", :state=>"published"}]          
      #   else
      #     LittleMarketCreation.all
      #   end
      # end

      get 'publish' do
        begin
          creation = Creation.find_by_lm_id params[:lm_id]          
          Rails.logger.debug "Publish crea #{creation.lm_id}"
          LittleMarketCreation.publish creation
          msg = "Votre creation '#{creation.title}' (#{creation.lm_id}) à bien été publiée sur LittleMarket"
        rescue Exception => e
          msg = "Error : #{e}"
          Rails.logger.error msg + e.backtrace.join("\n")
          error!({ msg: msg, title: creation.title }, 500)
        end
      end

      
      get '/delete' do
        begin
          Rails.logger.debug "Delete crea #{params[:lm_id]}"
          LittleMarketCreation.delete params[:lm_id]
          creation = Creation.find_by_lm_id params[:lm_id]
          msg = "Votre creation '#{creation.title}' (#{params[:lm_id]}} à bien été supprimée de LittleMarket"
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
