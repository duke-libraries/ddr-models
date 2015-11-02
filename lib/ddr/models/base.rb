module Ddr::Models
  class Base < ActiveFedora::Base
    extend Deprecation

    include ObjectApi
    include Describable
    include Governable
    include HasThumbnail
    include EventLoggable
    include FixityCheckable
    include FileManagement
    include Indexing
    include Hydra::Validations
    include HasAdminMetadata

    after_destroy do
      notify_event :deletion
    end

    def inspect
      "#<#{model_and_id}, uri: \"#{uri}\">"
    end

    def attached_files_profile
      AttachedFilesProfile.new(attached_files)
    end

    def copy_admin_policy_or_roles_from(other)
      copy_admin_policy_from(other) || copy_resource_roles_from(other)
    end

    def association_query(association)
      raise NotImplementedError, "The previous implementation does not work with ActiveFedora 9."
    end

    def model_and_id
      "#{self.class} id: #{id.inspect || '[NEW]'}"
    end

    def model_pid
      Deprecation.warn(Base, "`model_pid` is deprecated; use `model_and_id` instead.")
      model_and_id
    end

    # @override ActiveFedora::Core
    # See ActiveFedora overrides in engine initializers
    def adapt_to_cmodel
      super
    rescue ::TypeError
      raise ContentModelError, "Cannot adapt to nil content model."
    end

    def has_extracted_text?
      false
    end

    def adminMetadata
      self
    end

    # Moves the first (descriptive metadata) identifier into
    # (administrative metadata) local_id according to the following
    # rubric:
    #
    # No existing local_id:
    #   - Set local_id to first identifier value
    #   - Remove first identifier value
    #
    # Existing local_id:
    #   Same as first identifier value
    #     - Remove first identifier value
    #   Not same as first identifier value
    #     :replace option is true
    #       - Set local_id to first identifier value
    #       - Remove first identifier value
    #     :replace option is false
    #       - Do nothing
    #
    # Returns true or false depending on whether the object was
    # changed by this method
    def move_first_identifier_to_local_id(replace: true)
      moved = false
      identifiers = descMetadata.identifier.to_a
      first_id = identifiers.shift
      if first_id
        if local_id.blank?
          self.local_id = first_id
          self.descMetadata.identifier = identifiers
          moved = true
        else
          if local_id == first_id
            self.descMetadata.identifier = identifiers
            moved = true
          else
            if replace
              self.local_id = first_id
              self.descMetadata.identifier = identifiers
              moved = true
            end
          end
        end
      end
      moved
    end

  end
end
