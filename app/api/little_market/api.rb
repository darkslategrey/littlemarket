# coding: utf-8


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
        if ENV['RAILS_ENV'] == 'development'
          [{:id=>"15385431-toto", :imgs=>nil, :categs=>{:cat1=>"70", :cat2=>nil, :cat3=>nil}, :title=>"Programmes fait maison ", :subtitle=>"Artisanat numérique pour vos actions sur le web ", :desc=>"Automatiser vos actions sur le web. C'est mon métier. N'hésitez pas à me contacter pour ne plus vous faire de soucis avec les actions répétitives que vous faites. ", :tags=>["automatiser  ", "données  "], :materials=>["Autre", "Email"], :colors=>["Gris", "Turquoise"], :styles=>"", :events=>"", :dest=>nil, :prices=>{:prix_unitaire=>"50.00", :prix_solde=>"", :quantity=>"10"}, :deliveries=>{:delay=>"2", :profil=>"924223"}, :options=>{:reserve=>"", :date=>"0000-00-00 00"}}, {:id=>"15353631", :imgs=>nil, :categs=>{:cat1=>"70", :cat2=>nil, :cat3=>nil}, :title=>"Programmes fait maison ", :subtitle=>"Artisanat numérique pour vos actions sur le web ", :desc=>"Automatiser vos actions sur le web. C'est mon métier. N'hésitez pas à me contacter pour ne plus vous faire de soucis avec les actions répétitives que vous faites. ", :tags=>["automatiser  ", "données  "], :materials=>["Autre", "Email"], :colors=>["Gris", "Turquoise"], :styles=>"", :events=>"", :dest=>nil, :prices=>{:prix_unitaire=>"50.00", :prix_solde=>"", :quantity=>"10"}, :deliveries=>{:delay=>"2", :profil=>"924223"}, :options=>{:reserve=>"", :date=>"0000-00-00 00"}}]
        else
          LittleMarketCreation.all
        end
      end

    end

  end
end
