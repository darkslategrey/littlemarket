

module LittleMarket

  module Connector

    class Capy

      @@browser = Capybara::Session.new :poltergeist
      
      def self.login params
        username = params[:username]
        password = params[:password]
        @@browser.visit 'http://www.alittlemarket.com/'
        conn_window = @@browser.window_opened_by  do
          @@browser.click_on 'Se connecter'
        end
        @@browser.within_window conn_window do
          @@browser.fill_in 'login[username]' , :with => username
          @@browser.fill_in 'login[password]',  :with => password
          @@browser.click_button 'Se connecter'
        end
        @@connected = @@browser.has_text? /Bienvenue/
      end

      def self.get_creation url
        @@browser.visit url
        @@browser.html
      end
      
      def self.get_creations_list path
        @@browser.click_on 'a Mon compte'
        Capybara.app_host = 'http://www.alittlemarket.com'
        @@browser.visit '/page/creation/list.php'
        @@browser.html
      end
      
      def self.connected?
        @@connected
      end
      
    end

  end
end
