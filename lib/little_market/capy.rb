

module LittleMarket

  module Connector

    class ConnectorError < Exception; end
    
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

      def self.delete_creation id
        Capybara.app_host = 'http://www.alittlemarket.com'
        path = '/page/creation/list_action.php?action=delete&page=1&page_en_cours=1'
        path += "&sell_id=#{id}"
        Rails.logger.debug "app_host #{Capybara.app_host}"
        @@browser.visit path
        @@browser.save_screenshot '/tmp/screenshot'
        # @@browser.accept_alert do
        #   click_link('OK')
        # end
        if @@browser.status_code > 400
          raise ConnectorError.new("Error while deleting #{id} creation: #{@@browser.status_code}")
        end
      end
      
      def self.connected?
        @@connected
      end
      
    end

  end
end
