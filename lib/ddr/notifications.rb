module Ddr
  module Notifications

    FIXITY_CHECK = "fixity_check.events.ddr"
    VIRUS_CHECK = "virus_check.events.ddr"
    CREATION = "creation.events.ddr"
    UPDATE = "update.events.ddr"
    DELETION = "deletion.events.ddr"
    MIGRATION = "migration.events.ddr"

    def self.notify_event(type, args={}, &block)
      name = "#{type}.events.ddr"
      ActiveSupport::Notifications.instrument(name, args, &block)
    end

  end
end
