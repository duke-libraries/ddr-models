module Ddr
  module Events
    extend ActiveSupport::Autoload

    autoload :Event
    autoload :CreationEvent
    autoload :DeletionEvent
    autoload :FixityCheckEvent
    autoload :IngestionEvent
    autoload :MigrationEvent
    autoload :UpdateEvent
    autoload :ValidationEvent
    autoload :VirusCheckEvent
    autoload :PreservationEventBehavior
    autoload :ReindexObjectAfterSave
    autoload :ReplicationEvent
  end
end
