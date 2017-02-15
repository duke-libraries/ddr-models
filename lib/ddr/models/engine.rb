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

      initializer "active_fedora.content_model" do
        ActiveFedora::ContentModel.module_eval do
          # Returns the first known model for the object is equal to or a
          # subclass of the object's class.
          # This bubbles up, e.g., to prevent mis-casting via `.find`.
          def self.best_model_for(obj)
            known_models_for(obj).find { |model| model <= obj.class }
          end
        end
      end

      initializer "active_fedora.finder_methods" do
        ActiveFedora::FinderMethods.module_eval do
          # Override tries to cast by default
          def load_from_fedora(pid, cast)
            inner = ActiveFedora::DigitalObject.find(klass, pid)
            obj = klass.allocate.init_with_object(inner)
            if cast != false
              obj = obj.adapt_to_cmodel
            end
            obj
          end
        end
      end

      initializer "ddr_models.derivatives" do
        Ddr::Derivatives.update_derivatives = ENV['DERIVATIVES'] ?
                                                ENV['DERIVATIVES'].split(';').map { |deriv| deriv.strip.to_sym } :
                                                [ :thumbnail ]
      end

      initializer "ddr_models.external_files" do
        Ddr::Models.external_file_store = ENV["EXTERNAL_FILE_STORE"]
        Ddr::Datastreams::MultiresImageDatastream.file_store = ENV["MULTIRES_IMAGE_EXTERNAL_FILE_STORE"]
      end

      initializer "ddr_models.image_server" do
        Ddr::Models.image_server_url = ENV["IMAGE_SERVER_URL"]
      end

      # Add custom predicates to ActiveFedora
      initializer "ddr_models.predicates" do
        ActiveFedora::Predicates.set_predicates(Ddr::Metadata::PREDICATES)
      end

      # Set superuser group
      initializer "ddr_auth.superuser" do
        Ddr::Auth.superuser_group = ENV["SUPERUSER_GROUP"]
      end

      initializer "ddr_auth.collection_creators" do
        Ddr::Auth.collection_creators_group = ENV["COLLECTION_CREATORS_GROUP"]
      end

      # Set metadata managers group
      initializer "ddr_auth.metadata_managers_group" do
        Ddr::Auth.metadata_managers_group = ENV["METADATA_MANAGERS_GROUP"]
      end

      initializer "ezid_client" do
        unless Rails.env.production?
          require "ezid/test_helper"
          ezid_test_mode!
        end
      end

      initializer "fits_home" do
        Ddr::Models.fits_home = ENV["FITS_HOME"]
      end

      initializer "vips_path" do
        Ddr::Models.vips_path = ENV["VIPS_PATH"]
      end

      initializer "ddr_antivirus" do
        require "ddr-antivirus"
        if Rails.env.test?
          Ddr::Antivirus.test_mode!
        else
          Ddr::Antivirus.scanner_adapter = :clamd
        end
      end

    end
  end
end
