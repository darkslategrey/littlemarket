
require_relative './connector'


module LittleMarket
  class Connection

    # attr_reader :username, :password, :connector

    attr_accessor :connector, :username, :password, :browser

    @@connected = false
    @@browser   = nil
    
    def initialize params
      @username = params[:username]
      @password = params[:password]

      case params[:connector]
      when :net
        @connector = LittleMarket::Connector::Net
      when :capy
        @connector = LittleMarket::Connector::Capy
      end
    end

    def set_browser browser
      @@browser = browser
    end
    
    def self.browser
      @@browser
    end
    
    def login params
      begin
        login_params = {
          username:  params.fetch(:username, @username),
          password:  params.fetch(:password, @password),
        }
        connector = params.fetch(:connector, @connector)
        connector.login login_params
        @@connected = connector.connected?
      rescue Exception => e
        msg = "username: '#{params[:username]}'\n"
        msg += "password: '#{params[:password]}'\n"
        msg += "connector: '#{params[:connector]}'\n"                
        msg += " # #{e}"
        raise LittleMarket::ConnectionError.new msg
      end

    end

    def publish creation
      @connector.publish creation
    end
    
    def delete_creation id
      @connector.delete_creation id
    end
    
    def creation url
      @connector.get_creation url
    end
    
    def creations_list path
      @connector.get_creations_list path
    end
    
    def self.connected?
      @@connected
    end

    def connected?
      @@connected
    end
    
  end
end
