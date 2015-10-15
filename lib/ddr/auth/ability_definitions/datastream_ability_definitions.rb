module Ddr
  module Auth
    class DatastreamAbilityDefinitions < AbilityDefinitions

      # Maps datastream id to an ability required on the object to
      # download the datastream.
      #
      # Datastreams not listed cannot be downloaded, except of
      # course by the :manage ability.
      DATASTREAM_DOWNLOAD_ABILITIES = {
        Ddr::Datastreams::CONTENT         => :download,
        Ddr::Datastreams::EXTRACTED_TEXT  => :download,
        Ddr::Datastreams::FITS            => :read,
        Ddr::Datastreams::STRUCT_METADATA => :read,
        Ddr::Datastreams::THUMBNAIL       => :read,
      }.freeze

      def call
        can :download, ActiveFedora::File do |file|
          can_download_datastream?(_dsid(file), _pid(file))
        end
      end

      private

      def _dsid(file)
        File.basename(file.id)
      end

      def _pid(file)
        File.dirname(file.id)
      end

      def can_download_datastream?(dsid, pid)
        can? DATASTREAM_DOWNLOAD_ABILITIES.fetch(dsid), pid
      rescue KeyError
        false
      end

    end
  end
end
