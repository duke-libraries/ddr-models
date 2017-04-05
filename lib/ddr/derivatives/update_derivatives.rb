module Ddr::Derivatives
  class UpdateDerivatives

    def self.call(*args)
      event = ActiveSupport::Notifications::Event.new(*args)
      if event.name == "delete.repo_file" &&
         !file_ids.include?(event.payload[:file_id])
        return false
      end
      if event.name =~ /\.repo_object\z/ &&
         (file_ids & event.payload[:datastreams_changed]).empty?
        return false
      end
      obj = ActiveFedora::Base.find(event.payload[:pid])
      obj.derivatives.update_derivatives(:later)
    end

    def self.file_ids
      Ddr::Datastreams.update_derivatives_on_changed
    end

  end
end
