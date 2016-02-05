module Ddr::Jobs
  class DeleteMultiresImage
    extend Job

    @queue = :general

    def self.call(*args)
      event = ActiveSupport::Notifications::Event.new(*args)
      if event.name == Ddr::Notifications::DELETION &&
         file_uri = event.payload[:multires_image_file_path]
        Resque.enqueue(self, file_uri)
      end
    end

    def self.perform(file_uri)
      path = Ddr::Utils.path_from_uri(file_uri)
      File.unlink(path)
    end

  end
end
