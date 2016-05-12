require "resque"

module Ddr
  module Managers
    class DerivativesManager < Manager

      SCHEDULE_LATER = :later
      SCHEDULE_NOW = :now
      SCHEDULES = [ SCHEDULE_LATER, SCHEDULE_NOW ]

      ACTION_DELETE = "delete"
      ACTION_GENERATE = "generate"

      def update_derivatives(schedule=SCHEDULE_LATER)
        raise ArgumentError, "Must be one of #{SCHEDULES}" unless SCHEDULES.include?(schedule)
        Ddr::Derivatives.update_derivatives.each do |derivative_to_update|
          derivative = Ddr::Derivatives::DERIVATIVES[derivative_to_update]
            # Need to update derivative if either (or both) of the following conditions are true:
            # - object already has this derivative (need to delete or replace it)
            # - the derivative can be generated for this object
          if derivative.class.has_derivative?(object) || derivative.class.generatable?(object)
            schedule == SCHEDULE_NOW ? update_derivative(derivative) : Resque.enqueue(DerivativeJob, object.id, derivative_to_update)
          end
        end
      end

      def update_derivative(derivative)
        if derivative.class.generatable?(object)
          generate_derivative(derivative)
        else
          # Delete existing derivative (if there is one) if that type of derivative is no longer
          # applicable to the object
          if derivative.class.has_derivative?(object)
            delete_derivative(derivative)
          end
        end
      end

      def generate_derivative(derivative)
        ActiveSupport::Notifications.instrument(Ddr::Notifications::UPDATE,
                                                pid: object.id,
                                                summary: "Generate #{derivative.class.name} derivative"
                                                ) do |payload|
          derivative.generate!(object)
        end
      end

      def delete_derivative(derivative)
        ActiveSupport::Notifications.instrument(Ddr::Notifications::UPDATE,
                                                pid: object.id,
                                                summary: "Delete derivative #{derivative.class.name}"
                                                ) do |payload|
          derivative.delete!(object)
        end
      end

      def delete_derivative!(derivative)
        File.unlink *object.datastreams[derivative.datastream].file_paths if
                                                      object.datastreams[derivative.datastream].external?
        object.datastreams[derivative.datastream].delete
        object.save!
      end

      class DerivativeJob
        @queue = :derivatives
        def self.perform(id, derivative_name)
          object = ActiveFedora::Base.find(id)
          derivative = Ddr::Derivatives::DERIVATIVES[derivative_name.to_sym]
          object.derivatives.update_derivative(derivative)
        end
      end

    end
  end
end
