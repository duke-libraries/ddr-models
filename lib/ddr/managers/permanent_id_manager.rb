require "ezid-client"
require "resque"

module Ddr
  module Managers
    # 
    # PermanentIdManager is responsible for managing the permanent id for an object.
    #
    # @api private
    class PermanentIdManager

      PERMANENT_URL_BASE = "http://id.library.duke.edu/"
      TARGET_URL_BASE = "https://repository.lib.duke.edu/id/"

      ASSIGN_EVENT_SUMMARY = "Permanent ID assigned"

      SOFTWARE = Ezid::Client.version

      attr_reader :object

      def initialize(object)
        @object = object
      end

      def assign_later
        Resque.enqueue(AssignmentJob, object.pid)
      end

      def assign
        raise Ddr::Models::Error, "Permanent ID already assigned." if object.permanent_id
        ActiveSupport::Notifications.instrument(Ddr::Notifications::UPDATE,
                                                pid: object.pid, 
                                                software: SOFTWARE,
                                                summary: ASSIGN_EVENT_SUMMARY
                                                ) do |payload|

          assign!
          payload[:detail] = <<-EOS
Permanent ID:  #{object.permanent_id}
Permanent URL: #{object.permanent_url}
EZID Metadata:
#{record.metadata}
          EOS
        end
      end

      # A job class for background execution
      class AssignmentJob
        @queue = :permanent_id

        def self.perform(pid)
          object = ActiveFedora::Base.find(pid)
          object.permanent_id_manager.assign
        end
      end

      def default_metadata
        { profile: "dc", 
          export: "no" 
        }
      end

      def record
        return @record if @record
        if object.permanent_id
          @record = Ezid::Identifier.find(object.permanent_id.to_s)
        end
      end

      private

        def assign!
          @record = mint
          object.permanent_id = record.id
          object.permanent_url = (PERMANENT_URL_BASE + object.permanent_id)
          object.save
        end

        # @return [Ezid::Identifier]
        def mint
          ezid = Ezid::Identifier.create(default_metadata)
          ezid.target = default_target_url(ezid.id)
          ezid.save
          ezid
        end

        def default_target_url(id)
          TARGET_URL_BASE + id
        end

    end
  end
end
