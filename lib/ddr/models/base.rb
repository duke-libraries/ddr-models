module Ddr::Models
  class Base < ActiveFedora::Base
    extend Deprecation

    include ObjectApi
    include Governable
    include HasThumbnail
    include EventLoggable
    include FileManagement
    include Indexing
    include Hydra::Validations
    include HasAdminMetadata
    extend AutoVersion

    after_destroy do
      notify_event :deletion
    end

    DescriptiveMetadata.mapping.each do |name, term|
      property name, predicate: term.predicate do |index|
        index.as :stored_searchable
      end
    end

    def inspect
      "#<#{model_and_id}, uri: \"#{uri}\">"
    end

    def model_and_id
      "#{self.class} id: #{id.inspect || '[NEW]'}"
    end

    def model_pid
      Deprecation.warn(Base, "`model_pid` is deprecated; use `model_and_id` instead.")
      model_and_id
    end

    def descMetadata
      Deprecation.warn(Base, "`descMetadata` is deprecated; use `desc_metadata` instead.")
      desc_metadata
    end

    def desc_metadata
      @desc_metadata ||= DescriptiveMetadata.new(self)
    end

    def has_desc_metadata?
      desc_metadata.has_content?
    end

    def desc_metadata_terms(*args)
      return DescriptiveMetadata.unqualified_names.sort if args.empty?
      arg = args.pop
      terms = case arg.to_sym
              when :empty
                desc_metadata_terms.select { |t| desc_metadata.values(t).empty? }
              when :present
                desc_metadata_terms.select { |t| desc_metadata.values(t).present? }
              when :defined_attributes
                desc_metadata_terms & desc_metadata_attributes
              when :required
                desc_metadata_terms(:defined_attributes).select {|t| required? t}
              when :dcterms
                MetadataMapping.dc11.unqualified_names +
                  (MetadataMapping.dcterms.unqualified_names - MetadataMapping.dc11.unqualified_names)
              when :dcterms_elements11
                Ddr::Vocab::Vocabulary.term_names(::RDF::DC11)
              when :duke
                Ddr::Vocab::Vocabulary.term_names(Ddr::Vocab::DukeTerms)
              else
                raise ArgumentError, "Invalid argument: #{arg.inspect}"
              end
      if args.empty?
        terms
      else
        terms | desc_metadata_terms(*args)
      end
    end
    deprecation_deprecate :desc_metadata_terms

    def desc_metadata_attributes
      MetadataMapping.dc11.unqualified_names
    end
    deprecation_deprecate :desc_metadata_attributes

    def desc_metadata_values(term)
      Deprecation.warn(Base, "`desc_metadata_values` is deprecated; use `desc_metadata.values` instead.")
      desc_metadata.values(term)
    end

    def set_desc_metadata_values(term, values)
      Deprecation.warn(Base, "`set_desc_metadata_values` is deprecated; use `desc_metadata.set_values` instead.")
      desc_metadata.set_values(term, values)
    end

    # Update all desc_metadata terms with values in hash
    # Note that term not having key in hash will be set to nil!
    def set_desc_metadata(term_values_hash)
      desc_metadata_terms.each { |t| desc_metadata.set_values(t, term_values_hash[t]) }
    end

    def attached_files_profile
      AttachedFilesProfile.new(attached_files)
    end

    def copy_admin_policy_or_roles_from(other)
      copy_admin_policy_from(other) || copy_resource_roles_from(other)
    end

    def has_extracted_text?
      false
    end

    def adminMetadata
      self
    end

    def datastreams_to_validate
      Deprecation.warn(FixityCheckable, "`datastreams_to_validate` is deprecated." \
                                        " Use `attached_files_having_content` instead.")
      attached_files_having_content
    end

    def attached_files_having_content
      Hash.new.tap do |h|
        attached_files.each do |file_id, file|
          h[file_id] = file if file.has_content?
        end
      end
    end

    def fixity_checks
      Ddr::Events::FixityCheckEvent.for_object(self)
    end

    def check_fixity
      results = attached_files_having_content.each_with_object({}) do |(file_id, file), memo|
        memo[file_id] = !!file.check_fixity
      end
      notify_event(:fixity_check, results: results)
    end
    alias_method :fixity_check, :check_fixity
    deprecation_deprecate :fixity_check

    def last_fixity_check
      fixity_checks.last
    end

    def last_fixity_check_on
      last_fixity_check && last_fixity_check.event_date_time
    end

    def last_fixity_check_outcome
      last_fixity_check && last_fixity_check.outcome
    end

    def publishable?
      raise NotImplementedError, "Must be implemented by subclasses"
    end

  end
end
