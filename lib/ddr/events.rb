module Ddr
  module Events
    extend ActiveSupport::Autoload

    autoload :Event
    autoload :CreationEvent
    autoload :FixityCheckEvent
    autoload :IngestionEvent
    autoload :UpdateEvent
    autoload :ValidationEvent
    autoload :VirusCheckEvent
    autoload :PreservationEventType
    autoload :PreservationEventBehavior
    autoload :ReindexObjectAfterSave
    
  end
end