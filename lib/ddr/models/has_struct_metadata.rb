module Ddr
  module Models
    module HasStructMetadata
      extend ActiveSupport::Concern

      FILE_USE_MASTER = 'master'
      FILE_USE_REFERENCE = 'reference'

      included do
        has_metadata "structMetadata",
                     type: Ddr::Datastreams::StructMetadataDatastream,
                     versionable: true,
                     control_group: "M"

        has_attributes :file_group, :file_use, :order,
                       datastream: "structMetadata", multiple: false

        after_create :assign_struct_metadata!
      end

      def assign_struct_metadata!
        self.file_use = default_file_use if file_use.blank?
        self.order = default_order if order.nil?
        self.file_group = default_file_group if file_group.blank?
        save! if changed?
      end

      private

      def default_file_use
        if has_content?
          master_file? ? FILE_USE_MASTER : FILE_USE_REFERENCE
        end
      end

      def default_order
        siblings.size + 1
      end

      def default_file_group
        identifier.first if has_content?
      end

      def siblings
        if respond_to?(:parent) && parent.present?
          if file_use && parent.respond_to?(:children_by_file_use)
            sibs = parent.children_by_file_use[file_use]
          else
            sibs = parent.children
          end
        end
        sibs || []
      end

    end
  end
end
