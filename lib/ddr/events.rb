module Ddr
  module Events
    extend ActiveSupport::Autoload

    autoload :Event
    autoload :FixityCheckEvent
    autoload :UpdateEvent
    autoload :VirusCheckEvent
    autoload :PreservationEventBehavior
    autoload :ReindexObjectAfterSave
    
  end
end