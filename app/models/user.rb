class User < ActiveRecord::Base
  has_many :sessions
  has_secure_password validations: false
end
