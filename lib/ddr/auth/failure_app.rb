module Ddr
  module Auth
    class FailureApp < Devise::FailureApp

      def redirect
        store_location!
        if flash[:timedout] && flash[:alert]
          flash.keep(:timedout)
          flash.keep(:alert)
        end
        redirect_to redirect_url
      end

    end
  end
end
