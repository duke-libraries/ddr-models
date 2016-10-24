##
## Subscriptions to ActiveSupport::Notifications instrumentation events
##

# Fixity Checks
ActiveSupport::Notifications.subscribe(Ddr::Notifications::FIXITY_CHECK, Ddr::Events::FixityCheckEvent)

# Virus Checks
ActiveSupport::Notifications.subscribe(Ddr::Notifications::VIRUS_CHECK, Ddr::Events::VirusCheckEvent)

# Creation
ActiveSupport::Notifications.subscribe(Ddr::Notifications::CREATION, Ddr::Events::CreationEvent)

# Update
ActiveSupport::Notifications.subscribe(Ddr::Notifications::UPDATE, Ddr::Events::UpdateEvent)

# Deletion
ActiveSupport::Notifications.subscribe(Ddr::Notifications::DELETION, Ddr::Events::DeletionEvent)
ActiveSupport::Notifications.subscribe(/destroy\.\w+/, Ddr::Events::DeletionEvent)
ActiveSupport::Notifications.subscribe(/destroy\.\w+/, Ddr::Jobs::PermanentId::MakeUnavailable)

# Deaccession
ActiveSupport::Notifications.subscribe(/deaccession\.\w+/, Ddr::Events::DeaccessionEvent)
ActiveSupport::Notifications.subscribe(/deaccession\.\w+/, Ddr::Jobs::PermanentId::MakeUnavailable)
