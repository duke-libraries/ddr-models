module Ddr
  module Datastreams
    class RoleAssignmentsDatastream < ActiveFedora::NtriplesRDFDatastream

      vocabulary = Ddr::Metadata::RolesVocabulary

      vocabulary.each do |term|
        property Ddr::Metadata::Vocabulary.term_name(vocabulary, term), predicate: term do |index|
          index.as :symbol
        end
      end

      def principal_has_role?(principal, role)
        (send(role) & Array(principal)).any?
      end

    end
  end
end
