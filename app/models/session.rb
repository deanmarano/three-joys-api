class Session < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user
  before_save :create_token

  private

  def create_token
    self.token = JWT.encode({id: self.user.id, name: self.user.name, email: self.user.email}, ENV['secret'], 'HS512')
  end
end
