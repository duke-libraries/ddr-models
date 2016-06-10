module Ddr::Auth
  class WebAuthContext < AuthContext

    # @return [String] the IP address, or nil
    # @see ActionDispatch::RemoteIp
    def ip_address
      if middleware = env["action_dispatch.remote_ip"]
        middleware.calculate_ip
      end
    end

    # @return [Array<String>]
    def affiliation
      anonymous? ? super : split_env("affiliation").map { |a| a.sub(/@duke\.edu\z/, "") }
    end

    # @return [Array<String>]
    def ismemberof
      anonymous? ? super : split_env("ismemberof")
    end

    private

    def split_env(attr, delim = ";")
      env.fetch(attr, "").split(delim)
    end

  end
end
