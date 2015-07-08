module Ddr::Jobs
  class MigrateLegacyAuthorization

    @queue = :migration

    SUMMARY = "Legacy authorization data migrated to roles"

    def self.perform(pid)
      obj = ActiveFedora::Base.find(pid)
      event_args = { pid: pid, summary: SUMMARY }
      begin
        event_args[:detail] = obj.legacy_authorization.migrate
        obj.save!
      rescue Exception => e
        event_args[:exception] = e
        raise e
      ensure
        Ddr::Events::UpdateEvent.create(event_args)
      end
    end

  end
end
