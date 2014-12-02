module Ddr
  module Models
    module PermanentIdentification
      extend ActiveSupport::Concern

      PERMALINK_BASE_URL = 'http://id.library.duke.edu/'

      included do
        has_attributes :permanent_id, datastream: Ddr::Datastreams::PROPERTIES, multiple: false

        def self.permalink(permanent_id)
          permanent_id.present? ? PERMALINK_BASE_URL + permanent_id : nil
        end

      end

      def permalink
        self.class.permalink(permanent_id)
      end

    end
  end
end