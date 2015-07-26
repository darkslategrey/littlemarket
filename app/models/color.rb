class Color < ActiveRecord::Base


  def self.find_by_names names
    names.split(',').map do |c| Color.find_by_name(c).hex end
  end
  
end
