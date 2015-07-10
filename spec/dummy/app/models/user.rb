class User < ActiveRecord::Base
  include Ddr::Auth::User
  include Blacklight::User
end
