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

      def has_permission?(permission, obj)
        permissions(obj).include? permission
      end

      def permissions(obj)
        case obj
        when Ddr::Models::Base, SolrDocument
          cached_permissions obj.pid do
            effective_permissions obj
          end
        when String
          cached_permissions obj do
            effective_permissions permissions_doc(obj)
          end
        end
      end

      def effective_permissions(obj)
        EffectivePermissions.call(obj, agents)
      end

      def cached_permissions(pid, &block)
        cache[pid] ||= block.call
      end

      def permissions_doc(pid)
        roles_query_result = ActiveFedora::SolrService.query("id:\"#{pid}\"", rows: 1).first
        if roles_query_result.nil?
          raise "Solr document not found for PID \"#{pid}\"."
        end
        SolrDocument.new roles_query_result
      end

    end
  end
end
