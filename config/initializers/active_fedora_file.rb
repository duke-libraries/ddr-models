ActiveFedora::File.class_eval do
  after_save do
    ActiveSupport::Notifications.instrument(Ddr::Notifications::FILE_SAVE, uri: uri)
  end
end
