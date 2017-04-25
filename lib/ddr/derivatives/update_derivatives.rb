module Ddr::Derivatives
  class UpdateDerivatives

    def self.call(*args)
      event = ActiveSupport::Notifications::Event.new(*args)
      payload = event.payload
      return false if payload[:skip_update_derivatives]
      if event.name == "delete.repo_file" &&
         !file_ids.include?(payload[:file_id])
        return false
      end
      if event.name =~ /\.repo_object\z/ &&
         (file_ids & payload[:datastreams_changed]).empty?
        return false
      end
      obj = ActiveFedora::Base.find(payload[:pid])
      obj.derivatives.update_derivatives(:later)
    end

    def self.file_ids
      Ddr::Datastreams.update_derivatives_on_changed
    end

  end
end
