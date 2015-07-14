# coding: utf-8
class User < ActiveRecord::Base

  validates :username, presence: { message: 'Vous devez fournir votre login little market' }
  validates :password, presence: { message: 'Vous devez fournir le mot de passe de votre compte a little market' }
  validates :username, uniqueness: { message: 'Cet utilisateur est déjà enregistré' }

  def self.authenticate(user_info)
    find_by_username_and_password(user_info[:username],
                                  user_info[:password])
  end

  
end

