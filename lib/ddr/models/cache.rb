module Ddr::Models
  class Cache < Hash

    def get(key)
      self[key]
    end

    def put(key, value)
      self[key] = value
    end

    def with(options, &block)
      merge!(options)
      yield
      slice!(options.keys)
    end

  end
end
