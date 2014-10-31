require 'rails'

module Ddr
  module Models
    class Engine < ::Rails::Engine

      engine_name 'ddr_models'

      config.generators do |g|
        g.test_framework :rspec
        g.fixture_replacement :factory_girl
        g.assets false
        g.helper false
      end

      initializer 'ddr_model.predicates' do
        ActiveFedora::Predicates.set_predicates(Ddr::Metadata::PREDICATES)
      end

      initializer "ddr_models.factories", :after => "factory_girl.set_factory_paths" do
        FactoryGirl.definition_file_paths << File.expand_path('../../../../spec/factories', __FILE__) if defined?(FactoryGirl)
      end

    end
  end
end
