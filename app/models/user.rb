class User < ActiveRecord::Base
  has_many :destinations
  has_secure_password

end
