module Ddr::Jobs
  class MigrateLegacyAuthorization

    @queue = :migration

    SUMMARY = "Legacy authorization data migrated to roles"

    def self.perform(pid)
      obj = ActiveFedora::Base.find(pid)
      detail = obj.legacy_authorization.migrate
      obj.save!
      Ddr::Notifications.notify_event(:update,
                                      pid: pid,
                                      summary: SUMMARY,
                                      detail: detail
                                     )
    end

  end
end
