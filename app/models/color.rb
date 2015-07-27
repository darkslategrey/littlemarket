class Color < ActiveRecord::Base


  def self.find_by_names names
    names = names.gsub ' ', ''
    names.split(',').map do |c|
      Color.find_by_name(c.strip).hex
    end

  end
  
end
