module Ddr::Auth
  class Context

    attr_reader :env

    def initialize(env={})
      @env = env
    end

    # @return [String] the IP address, or nil
    # @see ActionDispatch::RemoteIp
    def ip_address
      if middleware = env["action_dispatch.remote_ip"]
        middleware.calculate_ip
      end
    end

    # @return [Array<String>]
    def affiliation
      split_env("affiliation")
    end

    # @return [Array<String>]
    def ismemberof
      split_env("ismemberof")
    end

    # @return [Array<Ddr::Auth::Group>]
    def groups
      ismemberof.map { |value| Group.new(value.sub(/\Aurn:mace:duke\.edu:groups/, "duke")) }
    end

    private

    def split_env(attr, delim = ";")
      env.fetch(attr, "").split(delim)
    end
    
  end
end
