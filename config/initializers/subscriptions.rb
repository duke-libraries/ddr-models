##
## Subscriptions to ActiveSupport::Notifications instrumentation events
##

# Fixity Checks
ActiveSupport::Notifications.subscribe(Ddr::Notifications::FIXITY_CHECK, Ddr::Events::FixityCheckEvent)

# Virus Checks
ActiveSupport::Notifications.subscribe(Ddr::Notifications::VIRUS_CHECK, Ddr::Events::VirusCheckEvent)

# Ingestion/Creation
ActiveSupport::Notifications.subscribe(Ddr::Notifications::CREATION, Ddr::Events::CreationEvent)
ActiveSupport::Notifications.subscribe(/create\.\w+/, Ddr::Events::IngestionEvent)

# Update
ActiveSupport::Notifications.subscribe(Ddr::Notifications::UPDATE, Ddr::Events::UpdateEvent)
ActiveSupport::Notifications.subscribe("assign.permanent_id", Ddr::Events::UpdateEvent)

# Deletion
ActiveSupport::Notifications.subscribe(Ddr::Notifications::DELETION, Ddr::Events::DeletionEvent)
ActiveSupport::Notifications.subscribe(/destroy\.\w+/, Ddr::Events::DeletionEvent)
ActiveSupport::Notifications.subscribe(/destroy\.\w+/, Ddr::Models::PermanentId)

# Deaccession
ActiveSupport::Notifications.subscribe(/deaccession\.\w+/, Ddr::Events::DeaccessionEvent)
ActiveSupport::Notifications.subscribe(/deaccession\.\w+/, Ddr::Models::PermanentId)

# Workflow
ActiveSupport::Notifications.subscribe(/workflow/, Ddr::Models::PermanentId)
