# coding: utf-8


module LittleMarket

  module Connector

    class ConnectorError < Exception; end
    
    class Capy

      @@browser  = Capybara::Session.new :poltergeist

      @@new_form = {
        '_action'=>'Form1',
        'actionHide'=>'continuer',
        'continuer'=>'continuer',
        'file'=>'',
        'id_photo[]'=>[],
        'input0'=>'1',
        'input1'=>'1',
        'input2'=>'1',
        'input3'=>'1',
        'input4'=>'1',
        'inputwizard'=>'',
        'photo0'=>'',
        'photo1'=>'',
        'photo2'=>'',
        'photo3'=>'',
        'photo4'=>''
        # 'trie$i'=>'100',
        # 'trie$i'=>'200',
        # 'trie$i'=>'300',
        # 'trie$i'=>'400',
        # 'trie$i'=>'500'
      }
      
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

      def self.publish creation

        Rails.logger.debug "Ces putains de cookies : #{@@browser.page.driver.cookies}"
        
        # form_to_post = @@new_form.merge! creation.to_new_form
        # Rails.logger.debug "form_to_post : <#{form_to_post}>"
        # Capybara.app_host = 'http://www.alittlemarket.com'
        # path = '/page/creation/add.php?action=add'
        # @@browser.visit path

        # categ, form_ssncateg, from_ncateg3_ss = creation.categs.split ','
        # !categ.blank?           && @@browser.select categ,           from: 'categ'
        # !form_ssncateg.blank?   && @@browser.select form_ssncateg,   from: 'form_ssncateg'
        # !form_ncateg3_ss.blank? && @@browser.select form_ncateg3_ss, from: 'form_ncateg3_ss'

        # @@browser.fill_in 'titre', creation.title
        # @@browser.fill_in 'texte', creation.desc
        
      end
      
      def self.delete_creation id
        Capybara.app_host = 'http://www.alittlemarket.com'
        path = '/page/creation/list_action.php?action=delete&page=1&page_en_cours=1'
        path += "&sell_id=#{id}"
        Rails.logger.debug "app_host #{Capybara.app_host}"
        @@browser.visit path
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
