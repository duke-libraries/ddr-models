class User < ActiveRecord::Base

  has_many :events, inverse_of: :user

  validates_presence_of :username

  def to_s
    username
  end

end
