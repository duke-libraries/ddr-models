##
## Subscriptions to ActiveSupport::Notifications instrumentation events
##

# Fixity Checks
ActiveSupport::Notifications.subscribe(Ddr::Notifications::FIXITY_CHECK, Ddr::Events::FixityCheckEvent)

# Virus Checks
ActiveSupport::Notifications.subscribe(Ddr::Notifications::VIRUS_CHECK, Ddr::Events::VirusCheckEvent)

# Ingestion/Creation
ActiveSupport::Notifications.subscribe(Ddr::Notifications::CREATION, Ddr::Events::CreationEvent)
ActiveSupport::Notifications.subscribe(/^ingestion\.\w+\.repo_object/, Ddr::Events::IngestionEvent)

# Update
ActiveSupport::Notifications.subscribe(Ddr::Notifications::UPDATE, Ddr::Events::UpdateEvent)
ActiveSupport::Notifications.subscribe(/^update\.\w+\.repo_object/, Ddr::Events::UpdateEvent)

# Deletion
ActiveSupport::Notifications.subscribe(Ddr::Notifications::DELETION, Ddr::Events::DeletionEvent)
ActiveSupport::Notifications.subscribe(/^deletion\.\w+\.repo_object/, Ddr::Models::PermanentId)
ActiveSupport::Notifications.subscribe(/^deletion\.\w+\.repo_object/, Ddr::Events::DeletionEvent)

# Deaccession
ActiveSupport::Notifications.subscribe(/^deaccession\.\w+\.repo_object/, Ddr::Models::PermanentId)
ActiveSupport::Notifications.subscribe(/^deaccession\.\w+\.repo_object/, Ddr::Events::DeaccessionEvent)

# Workflow
ActiveSupport::Notifications.subscribe(/workflow/, Ddr::Models::PermanentId)
