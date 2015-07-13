class User < ActiveRecord::Base


  def self.authenticate(user_info)
    find_by_username_and_password(user_info[:username],
                                  user_info[:password])
  end

  
end

