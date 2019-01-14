require 'valkyrie'

Rails.application.config.to_prepare do

  ## Metadata Adapters

  Valkyrie::MetadataAdapter.register(
      Valkyrie::Persistence::Memory::MetadataAdapter.new,
      :memory
  )

  Valkyrie::MetadataAdapter.register(
      Valkyrie::Persistence::Postgres::MetadataAdapter.new,
      :postgres
  )

  ## Storage Adapters

  Valkyrie::StorageAdapter.register(
      Valkyrie::Storage::Memory.new,
      :memory
  )

  Valkyrie::StorageAdapter.register(
      Valkyrie::Storage::Disk.new(
          base_path: Rails.root.join("tmp", "files"),
          file_mover: FileUtils.method(:cp)
      ),
      :disk
  )

end
