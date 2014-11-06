class User < ActiveRecord::Base

  include Ddr::Auth::User

end
