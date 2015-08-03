# coding: utf-8

module LittleMarket

  module Connector

    class ConnectorError < Exception; end
    
    class Capy

      @@browser  = Capybara::Session.new :poltergeist
      @@cpt      = 0
      @@cookies  = ''
      
      @@new_form = {
        '_action'=>'Form1',
        'actionHide'=>'continuer',
        'continuer'=>'continuer',
        'file'=>'',
        # 'id_photo[]'=>[],
        'input0'=>'1',
        'input1'=>'1',
        'input2'=>'1',
        'input3'=>'1',
        'input4'=>'1',
        'inputwizard'=>'',
        # 'photo0'=>'',
        # 'photo1'=>'',
        # 'photo2'=>'',
        # 'photo3'=>'',
        # 'photo4'=>''
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

      def self.set_cookies
        # cookie  = @@browser.driver.cookies['sessid']
        local_cookies = []
        @@browser.driver.cookies.each_key do |k|
          Rails.logger.debug "#{@@browser.driver.cookies[k].name}=#{@@browser.driver.cookies[k].value}"
          local_cookies << "#{@@browser.driver.cookies[k].name}=#{@@browser.driver.cookies[k].value}"
        end
        @@cookies = local_cookies.join ';'
      end


      def self.get_img url, creation_id, cpt
        host = 'http://galerie.alittlemarket.com'
        conn = Faraday.new(:url => host) do |faraday|
          faraday.request  :url_encoded             # form-encode POST params
          faraday.response :logger                  # log requests to STDOUT
          faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
          faraday.use FaradayMiddleware::FollowRedirects, limit: 3    
        end
        response = conn.get url
        img_path = Rails.root.join('imgs', creation_id.to_s, url.split('/')[-1]).to_s
        FileUtils.mkdir_p File.dirname(img_path)
        outfile = File.dirname(img_path) + File::SEPARATOR + "img-#{cpt}.jpg"
        IO.binwrite outfile, response.body
        # File.open(img_path, 'w') do |f|
        #   f.write response.body
        # end
        outfile
      end

      def self.post_imgs imgs_paths
        host = 'http://www.alittlemarket.com'
        headers = {
          'User-Agent' => 'Mozilla/5.0 (X11; Linux x86_64; rv:39.0) Gecko/20100101 Firefox/39.0',
          'Accept'     => 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
          'Accept-Language' => 'en-US,en;q=0.5',
          'Accept-Encoding' => 'gzip, deflate',
          'X-Requested-With' => 'XMLHttpRequest',
          # 'Content-Type'     => 'application/octet-stream',
          'Referer'          => 'http://www.alittlemarket.com/page/creation/add.php?action=add',
          'Connection'       => 'keep-alive',
          'Pragma'           => 'no-cache',
          'Cache-Control'    => 'no-cache',
          'Cookie'           => @@cookies
        }



        # conn = Faraday.new(:url => host) do |faraday|

        #   # POST/PUT params encoders:
        #   faraday.request :multipart
        #   faraday.request :url_encoded
        #   faraday.response :logger
        #   faraday.headers = headers # merge!(headers)
        #   faraday.adapter :net_http
        # end
        i = 0
        img_ids = []
        imgs_paths.split(',').each do |path|
          Rails.logger.debug "DEBUG : img path '#{path}'"
          # payload[:profile_pic] = Faraday::UploadIO.new(path, 'image/jpeg')
          url = "/upload.php?sell_id=&dup_id=&nbFile=1&trie=100&qqfile=img-#{i}.jpg"
          response = RestClient.post host+url, File.new(path, 'rb'), headers
          # payload  = { :file => Faraday::UploadIO.new(path, 'image/jpeg') }
          # response = conn.post url, payload
          # response = conn.post do |req|
          #   req.url url
          #   req.body = Faraday::UploadIO.new(path, 'image/jpeg')
          # end
          # body     = IO.binread path
          # headers['X-File-Name']      = "img-#{i}.jpg"
          # headers['Content-Length']   = body.length.to_s
          # response = conn.post do |req|
          #   req.url path
          #   req.body    = body
          #   req.headers = headers
          # end
          # io          = StringIO.new(response.body)
          # gzip_reader = Zlib::GzipReader.new(io)
          # Rails.logger.debug "RESONSE #{gzip_reader.read}"
          Rails.logger.debug "RESONSE #{response.body}"
          json_response = JSON.parse(response.body)
          raise "Erreur lors de la publication des images" if json_response['success'] == false
          img_ids << { id: json_response['id'], realfilename: json_response['realfilename'] }
          i += 1
        end
        Rails.logger.debug "IMGS IDS #{img_ids}"
        img_ids
      end
      
      def self.publish creation

        @@cookies.blank? and self.set_cookies
        Rails.logger.debug "COOKIES #{@@cookies}"
        
        # session = {}
        
        # [:domain, :path, :secure?, :httponly?, :expires].each do |p|
        #   session[p] = cookie.send p
        # end
        # session_cookie = HTTP::Cookie.new(cookie.name, cookie.value, session)
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
        img_ids      = post_imgs creation.imgs
        i = -1
        photo_params = img_ids.map do |element|
          i += 1          
          "id_photo[]=#{element[:id]}&photo#{i}=#{element[:realfilename]}"
        end.join('&')
        post_data += '&' + photo_params

        Rails.logger.debug "POST DATA #{post_data}"
        resp = conn.post('/page/creation/add.php?action=add') do |request|
          request.headers.merge!({ :Cookie => @@cookies }) # session_cookie.set_cookie_value})
          request.body = post_data
        end
        # Rails.logger.debug resp.body
        # File.open('/tmp/out.html', 'wb') do |f| f.write(resp.body) end
        nokodoc = Nokogiri::HTML(resp.body)
        nokodoc.xpath('//li[@class="errors"]').each do |error|
          Rails.logger.error "PUBLISH ERROR '#{error.text}" 
        end
        resp = conn.get '/page/creation/list.php' do |request|
          request.headers.merge!({ :Cookie => @@cookies })
        end
        nokodoc = Nokogiri::HTML(resp.body)        
        xpath = '//table[@id="creation"]'
        table = nokodoc.xpath(xpath)
        tr    = table.first.xpath('.//tr').first
        # Rails.logger.debug "TR @@@@@@@@@ #{tr.to_html}"
        td    = tr.xpath('./td').children[1]
        # Rails.logger.debug "TD @@@@@@@@@ #{td.to_html}"
        new_id= td.attr('value')
        # Rails.logger.debug "LINK @@@@@@@@@@@ #{new_id}"
        # new_id = link.split('&')[2].split('=')[1]
        
        # xpath   = '//table[@id="creation"]/tr[2]/td[4]/span[2]'
        # Rails.logger.debug "NOKODOC #{nokodoc.xpath(xpath).count}"
        # new_id  = nokodoc.xpath(xpath).first.text.split(':')[1]
        Rails.logger.debug "OLD ID #{creation.lmid} NEW ID #{new_id}"        
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
