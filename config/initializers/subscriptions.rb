##
## Subscriptions to ActiveSupport::Notifications instrumentation events
##

models = %w( collection item component target attachment ).join("|")
has_content = %w( component target attachment ).join("|")

# Fixity Checks
ActiveSupport::Notifications.subscribe(Ddr::Notifications::FIXITY_CHECK, Ddr::Events::FixityCheckEvent)

# Virus Checks
ActiveSupport::Notifications.subscribe(Ddr::Notifications::VIRUS_CHECK, Ddr::Events::VirusCheckEvent)

# Ingestion/Creation
ActiveSupport::Notifications.subscribe(Ddr::Notifications::CREATION, Ddr::Events::CreationEvent)
ActiveSupport::Notifications.subscribe(/^ingestion\.(#{models})\.repo_object/, Ddr::Events::IngestionEvent)

# Update
ActiveSupport::Notifications.subscribe(Ddr::Notifications::UPDATE, Ddr::Events::UpdateEvent)
ActiveSupport::Notifications.subscribe(/^update\.(#{models})\.repo_object/, Ddr::Events::UpdateEvent)

# Deletion/Deaccession
ActiveSupport::Notifications.subscribe(Ddr::Notifications::DELETION, Ddr::Events::DeletionEvent)
ActiveSupport::Notifications.subscribe(/^(deletion|deaccession)\.(#{models})\.repo_object/, Ddr::Models::PermanentId)
ActiveSupport::Notifications.subscribe(/^deletion\.(#{models})\.repo_object/, Ddr::Events::DeletionEvent)
ActiveSupport::Notifications.subscribe(/^deaccession\.(#{models})\.repo_object/, Ddr::Events::DeaccessionEvent)

# Workflow
ActiveSupport::Notifications.subscribe(/workflow/, Ddr::Models::PermanentId)

# Derivatives
update_derivs = Ddr::Datastreams.update_derivatives_on_changed.join("|")
ActiveSupport::Notifications.subscribe(/^(ingestion|update)\.(#{has_content})\.repo_object/, Ddr::Derivatives::UpdateDerivatives)
ActiveSupport::Notifications.subscribe(/^delete\.(#{update_derivs})\.datastream/, Ddr::Derivatives::UpdateDerivatives)
