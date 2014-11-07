module Ddr
  module Models
    module PermanentIdentification
      extend ActiveSupport::Concern

      PERMALINK_BASE_URL = 'http://id.library.duke.edu/'

      included do
        has_attributes :permanent_id, datastream: Ddr::Datastreams::PROPERTIES, multiple: false
        after_create :assign_permanent_identifier

        def self.permalink(permanent_id)
          PERMALINK_BASE_URL + permanent_id
        end

      end

      def permalink
        self.class.permalink(permanent_id)
      end

      protected

      def assign_permanent_identifier
        reload
        unless permanent_id.present?
          event_args = { pid: self.pid, summary: "Assigned permanent ID" }
          begin
            self.permanent_id = Ddr::Services::IdService.mint
            if save(validate: false)
              MintedId.find_by(minted_id: self.permanent_id).update(referent: self.pid)
              event_args[:outcome] = Ddr::Events::Event::SUCCESS
              event_args[:detail] = "Assigned permanent ID #{self.permanent_id} to #{self.pid}"
            else
              raise "Could not save object #{self.pid} with permanent identifier #{self.permanent_id}"
            end
          rescue Exception => e
            event_args[:outcome] = Ddr::Events::Event::FAILURE
            event_args[:detail] = "Unable to assign permanent ID to #{self.pid}"
            Rails.logger.error("Error assigning permanent ID to #{self.pid}: #{e}")
          end
          Ddr::Notifications.notify_event(:update, event_args)
        end
      end

    end
  end
end