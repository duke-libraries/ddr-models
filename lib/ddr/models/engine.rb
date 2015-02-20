require "rails"

module Ddr
  module Models
    class Engine < ::Rails::Engine

      engine_name "ddr_models"

      config.generators do |g|
        g.test_framework :rspec
        g.fixture_replacement :factory_girl
        g.assets false
        g.helper false
      end

      #
      # Initializers
      #
      initializer "ddr_models.external_files" do
        Ddr::Models.external_file_store = ENV["EXTERNAL_FILE_STORE"]
        Ddr::Models.external_file_subpath_pattern = ENV["EXTERNAL_FILE_SUBPATH_PATTERN"] || "--"
      end

      # Add custom predicates to ActiveFedora
      # initializer "ddr_models.predicates" do
      #   ActiveFedora::Predicates.set_predicates(Ddr::Metadata::PREDICATES)
      # end

      # Integration of remote (Grouper) groups via Shibboleth
      initializer "ddr_auth.grouper" do
        # Load configuration for Grouper service, if present
        if File.exists? "#{Rails.root}/config/grouper.yml"
          Ddr::Auth::GrouperService.config = YAML.load_file("#{Rails.root}/config/grouper.yml")[Rails.env]
        end

        Warden::Manager.after_set_user do |user, auth, opts|
          user.group_service = Ddr::Auth::RemoteGroupService.new(auth.env)
        end
      end

      # Set superuser group
      initializer "ddr_auth.superuser" do
        Ddr::Auth.superuser_group = ENV["SUPERUSER_GROUP"]
      end

      initializer "ddr_auth.collection_creators" do
        Ddr::Auth.collection_creators_group = ENV["COLLECTION_CREATORS_GROUP"]
      end

      initializer "ezid_client" do
        unless Rails.env.production?
          require "ezid/test_helper"
          ezid_test_mode!
        end
      end

    end
  end
end
