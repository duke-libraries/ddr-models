module Ddr::Events
  class UpdateEvent < Event
    self.description = "Object updated"

    def self.call(*args)
      super do |event, notification|
        attrs_changed = notification.payload[:attributes_changed]
        ds_changed = notification.payload[:datastreams_changed]
        event.detail = ["Attributes changed: #{attrs_changed}",
                        "Datastreams changed: #{ds_changed.join(', ')}",
                        event.detail,
                       ].compact.join("\n\n")
      end
    end
  end
end
