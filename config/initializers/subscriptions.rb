##
## Subscriptions to ActiveSupport::Notifications instrumentation events
##

# Fixity Checks
ActiveSupport::Notifications.subscribe(Ddr::Notifications::FIXITY_CHECK, Ddr::Events::FixityCheckEvent)

# Virus Checks
ActiveSupport::Notifications.subscribe(Ddr::Notifications::VIRUS_CHECK, Ddr::Events::VirusCheckEvent)

# Ingestion/Creation
ActiveSupport::Notifications.subscribe(Ddr::Notifications::CREATION, Ddr::Events::CreationEvent)
ActiveSupport::Notifications.subscribe(Ddr::Models::Base::INGEST, Ddr::Events::IngestionEvent)
ActiveSupport::Notifications.subscribe(Ddr::Models::Base::INGEST, Ddr::Derivatives::UpdateDerivatives)

# Update
ActiveSupport::Notifications.subscribe(Ddr::Notifications::UPDATE, Ddr::Events::UpdateEvent)
ActiveSupport::Notifications.subscribe(Ddr::Models::Base::UPDATE, Ddr::Events::UpdateEvent)
ActiveSupport::Notifications.subscribe(Ddr::Models::Base::UPDATE, Ddr::Models::PermanentId)
ActiveSupport::Notifications.subscribe(Ddr::Models::Base::UPDATE, Ddr::Derivatives::UpdateDerivatives)

# Delete
ActiveSupport::Notifications.subscribe(Ddr::Notifications::DELETION, Ddr::Events::DeletionEvent)
ActiveSupport::Notifications.subscribe(Ddr::Models::Base::DELETE, Ddr::Models::PermanentId)
ActiveSupport::Notifications.subscribe(Ddr::Models::Base::DELETE, Ddr::Events::DeletionEvent)
ActiveSupport::Notifications.subscribe(Ddr::Models::Base::DELETE, Ddr::Datastreams::DeleteExternalFiles)

# Deaccession
ActiveSupport::Notifications.subscribe(Ddr::Models::Base::DEACCESSION, Ddr::Models::PermanentId)
ActiveSupport::Notifications.subscribe(Ddr::Models::Base::DEACCESSION, Ddr::Events::DeaccessionEvent)
ActiveSupport::Notifications.subscribe(Ddr::Models::Base::DEACCESSION, Ddr::Datastreams::DeleteExternalFiles)

# Files
ActiveSupport::Notifications.subscribe(Ddr::Datastreams::DELETE, Ddr::Derivatives::UpdateDerivatives)
ActiveSupport::Notifications.subscribe(Ddr::Datastreams::DELETE, Ddr::Datastreams::DeleteExternalFiles)
