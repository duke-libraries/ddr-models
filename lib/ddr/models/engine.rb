require 'rails'

module Ddr
  module Models
    class Engine < ::Rails::Engine

      config.generators do |g|
        g.test_framework :rspec
        g.fixture_replacement :factory_girl
        g.assets false
        g.helper false
      end

    end
  end
end
