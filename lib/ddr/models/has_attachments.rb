module Ddr
  module Models
    module HasAttachments
      extend ActiveSupport::Concern

      included do
        has_many :attachments,
                 predicate: ::RDF::URI("http://projecthydra.org/ns/relations#isAttachedTo"),
                 class_name: 'Attachment'
      end

    end
  end
end
