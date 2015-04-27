module Ddr
  module Events
    extend ActiveSupport::Autoload

    autoload :Event
    autoload :CreationEvent
    autoload :DeletionEvent
    autoload :FixityCheckEvent
    autoload :IngestionEvent
    autoload :UpdateEvent
    autoload :ValidationEvent
    autoload :VirusCheckEvent
    autoload :PreservationEventBehavior
    autoload :ReindexObjectAfterSave

  end
end
