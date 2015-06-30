module Ddr
  module Auth
    class DatastreamAbilityDefinitions < AbilityDefinitions

      # Maps datastream id to an ability required on the object to
      # download the datastream.
      #
      # Datastreams not listed cannot be downloaded, except of
      # course by the :manage ability.
      DATASTREAM_DOWNLOAD_ABILITIES = {
        Ddr::Datastreams::CONTENT        => :download,
        Ddr::Datastreams::DESC_METADATA  => :read,
        Ddr::Datastreams::EXTRACTED_TEXT => :read,
        Ddr::Datastreams::MULTIRES_IMAGE => :read,
        Ddr::Datastreams::THUMBNAIL      => :read,
      }.freeze

      def call
        can :download, ActiveFedora::Datastream do |ds|
          can_download_datastream?(ds.dsid, ds.pid)
        end
      end

      private

      def can_download_datastream?(dsid, pid)
        can? DATASTREAM_DOWNLOAD_ABILITIES.fetch(dsid), pid
      rescue KeyError
        false
      end

    end
  end
end
