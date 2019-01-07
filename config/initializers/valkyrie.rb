# frozen_string_literal: true
require 'blacklight'
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

  Valkyrie::MetadataAdapter.register(
      Valkyrie::Persistence::Solr::MetadataAdapter.new(
          connection: Blacklight.default_index.connection,
          resource_indexer: Valkyrie::Persistence::Solr::CompositeIndexer.new(
              Valkyrie::Indexers::AccessControlsIndexer
          )
      ),
      :index_solr
  )

  # Valkyrie::MetadataAdapter.register(
  #     IndexingAdapter.new(metadata_adapter: Valkyrie::MetadataAdapter.find(:postgres),
  #                         index_adapter: Valkyrie::MetadataAdapter.find(:index_solr)),
  #     :indexing_adapter
  # )
  #
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

  # [ FindByIdentifierPostgres ].each do |query_handler|
  #   Valkyrie::MetadataAdapter.find(:postgres).query_service.custom_queries.register_query_handler(query_handler)
  # end
  #
end
