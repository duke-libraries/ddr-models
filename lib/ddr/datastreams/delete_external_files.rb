require 'uri'

module Ddr::Datastreams
  class DeleteExternalFiles

    def self.call(*args)
      event = ActiveSupport::Notifications::Event.new(*args)
      case event.name
      when Ddr::Datastreams::DELETE
        delete_files(event.payload[:version_history])
      when Ddr::Models::Base::DELETE, Ddr::Models::Base::DEACCESSION
        delete_files(event.payload[:datastream_history].values.flatten)
      end
    end

    def self.get_files_to_delete(profiles)
      return [] if profiles.empty?
      profiles
        .select { |prof| (prof["dsControlGroup"] == "E") && prof["dsLocation"].start_with?("file:") }
        .map    { |prof| Ddr::Utils.path_from_uri(prof["dsLocation"]) }
    end

    def self.delete_files(profiles)
      paths = get_files_to_delete(profiles)
      FileUtils.rm_f(paths) unless paths.empty?
    end

  end
end
