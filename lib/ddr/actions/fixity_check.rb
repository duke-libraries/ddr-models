module Ddr
  module Actions
    class FixityCheck

      # Return result of fixity check - wrapped by a notifier
      def self.execute(object)
        ActiveSupport::Notifications.instrument(Ddr::Notifications::FIXITY_CHECK) do |payload|
          payload[:result] = _execute(object)
        end
      end

      # Return result of fixity check
      def self._execute(object)
        Result.new(id: object.id).tap do |r|
          object.datastreams_to_validate.each do |dsid, ds|
            # r.success &&= ds.dsChecksumValid
            # r.results[dsid] = ds.profile
            checksum_valid = ds.check_fixity
            r.success &&= checksum_valid
            r.results[dsid] = { 'checksum_valid' => checksum_valid }
          end
        end
      end

      class Result
        attr_accessor :id, :success, :results, :checked_at

        def initialize(args={})
          @id = args[:id]
          @success = args[:success] || true
          @results = args[:results] || {}
          @checked_at = args[:checked_at] || Time.now.utc
        end
      end

    end
  end
end
