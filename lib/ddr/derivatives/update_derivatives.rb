module Ddr::Derivatives
  class UpdateDerivatives

    def self.call(*args)
      event = ActiveSupport::Notifications::Event.new(*args)

      if event.name =~ /\.repo_object\z/ &&
         ( Ddr::Datastreams.update_derivatives_on_changed &
           event.payload[:datastreams_changed] ).empty?
        return false
      end

      obj = ActiveFedora::Base.find(event.payload[:pid])
      obj.derivatives.update_derivatives(:later)
    end

  end
end
