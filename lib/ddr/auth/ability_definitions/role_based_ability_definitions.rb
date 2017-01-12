module Ddr
  module Auth
    class RoleBasedAbilityDefinitions < AbilityDefinitions

      def call
        Permissions::ALL.each do |permission|
          can permission, [Ddr::Models::Base, SolrDocument, String] do |obj|
            has_permission? permission, obj
          end
        end
      end

      private

      def has_permission?(permission, object_or_id)
        permissions(object_or_id).include? permission
      end

      def permissions(object_or_id)
        case object_or_id
        when Ddr::Models::Base, SolrDocument
          cached_permissions(object_or_id.id) do
            object_or_id.effective_permissions(agents)
          end
        when String
          cached_permissions(object_or_id) do
            doc = SolrDocument.find(object_or_id) # raises SolrDocument::NotFound
            doc.effective_permissions(agents)
          end
        end
      end

      def cached_permissions(pid, &block)
        cache[pid] ||= block.call
      end

    end
  end
end
