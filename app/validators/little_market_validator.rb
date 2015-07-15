
require_relative '../../lib/little_market'

class LittleMarketValidator < ActiveModel::Validator


  def validate(record)

    return if !record.check_little_ids

    connection = ::LittleMarket::Connection.new record.username, record.password
    
    err = "Vos identifiants ne sont pas reconnus par Little Market : "
    err += "#{record.username} / #{record.password}"
    record.errors[:base] << err unless connection.connected?
    
  end

  
end
