# coding: utf-8


module LittleMarket

  module Connector

    class ConnectorError < Exception; end
    
    class Capy

      @@browser  = Capybara::Session.new :poltergeist
      @@cpt      = 0
      
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
        ccpt = 0
        while ccpt < 10
          break if @@browser.has_xpath?('//select[@id="form_ssncateg"]')
          sleep 2
          ccpt += 1
        end
        html = @@browser.html        
        File.open("/tmp/html_1_#{@@cpt}.html", 'w') { |file| file.write(html) }
        @@cpt += 1
        # find(:xpath, "//table/tr").click                
        html
      end
      
      def self.get_creations_list path
        @@browser.click_on 'a Mon compte'
        Capybara.app_host = 'http://www.alittlemarket.com'
        @@browser.visit '/page/creation/list.php'
        @@browser.html
      end

      def self.publish creation

        cookie  = @@browser.driver.cookies['sessid']
        cookies = []
        @@browser.driver.cookies.each_key do |k|
          Rails.logger.debug "#{@@browser.driver.cookies[k].name}=#{@@browser.driver.cookies[k].value}"
          cookies << "#{@@browser.driver.cookies[k].name}=#{@@browser.driver.cookies[k].value}"
        end
        cookies = cookies.join ';'

        Rails.logger.debug "COOKIES #{cookies}"
        
        session = {}
        
        [:domain, :path, :secure?, :httponly?, :expires].each do |p|
          session[p] = cookie.send p
        end
        session_cookie = HTTP::Cookie.new(cookie.name, cookie.value, session)
        # Rails.logger.debug "methods " + session_cookie.methods.sort.join("\n")
        # Rails.logger.debug "cookie value #{session_cookie.set_cookie_value}"
        # Rails.logger.debug "Ces putains de cookies : #{session}"
        url = 'http://www.alittlemarket.com'
        conn = Faraday.new(:url => url) do |faraday|
          faraday.request  :url_encoded
          faraday.response :logger
          faraday.use FaradayMiddleware::FollowRedirects, limit: 3
          faraday.use :cookie_jar # , jar: session_cookie
          faraday.adapter  Faraday.default_adapter
        end
        post_data = @@new_form.to_param + '&' + creation.to_new_form
        Rails.logger.debug "POST DATA #{post_data}"
        resp = conn.post('/page/creation/add.php?action=add') do |request|
          request.headers.merge!({ :Cookie => cookies }) # session_cookie.set_cookie_value})
          request.body = post_data
        end
        # Rails.logger.debug resp.body
        nokodoc = Nokogiri::HTML(resp.body)
        nokodoc.xpath('//li[@class="errors"]').each do |error|
          Rails.logger.error "PUBLISH ERROR '#{error.text}" 
        end

        xpath = '//table[@id="creation"]'
        table = nokodoc.xpath(xpath)
        tr    = table.first.xpath('.//tr').first
        Rails.logger.debug "TR @@@@@@@@@ #{tr.to_html}"
        td    = tr.xpath('./td').children[1]
        Rails.logger.debug "TD @@@@@@@@@ #{td.to_html}"
        new_id= td.attr('value')
        # Rails.logger.debug "LINK @@@@@@@@@@@ #{new_id}"
        # new_id = link.split('&')[2].split('=')[1]
        
        # xpath   = '//table[@id="creation"]/tr[2]/td[4]/span[2]'
        # Rails.logger.debug "NOKODOC #{nokodoc.xpath(xpath).count}"
        # new_id  = nokodoc.xpath(xpath).first.text.split(':')[1]
        Rails.logger.debug "NEW ID #{new_id}"        
        creation.update_attributes! lmid: new_id
        # resp
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
