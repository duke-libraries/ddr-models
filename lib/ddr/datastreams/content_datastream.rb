module Ddr::Datastreams
  class ContentDatastream < ExternalFileDatastream

    CONTENT_CHANGED = "content_changed.content.repo_file"

    around_save :notify_content_changed, if: [:external?, :dsLocation_changed?]

    private

    def notify_content_changed
      ActiveSupport::Notifications.instrument(CONTENT_CHANGED, pid: pid) do |payload|
        yield
      end
    end

  end
end
