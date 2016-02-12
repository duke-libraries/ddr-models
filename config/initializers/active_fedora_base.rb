ActiveFedora::Base.class_eval do

    def can_have_attachments?
      has_association? :attachments
    end

    def has_attachments?
      can_have_attachments? && attachments.size > 0
    end

    def can_have_children?
      has_association? :children
    end

    def has_children?
      can_have_children? and children.size > 0
    end

    def can_have_content?
      datastreams.key? "content"
    end

    def has_content?
      can_have_content? && content.has_content?
    end

    def describable?
      self.is_a? Ddr::Models::Base
    end
    deprecation_deprecate :describable?

    def governable?
      has_association? :admin_policy
    end

    def has_admin_policy?
      governable? && admin_policy.present?
    end

    def can_have_struct_metadata?
      datastreams.key? Ddr::Models::File::STRUCT_METADATA
    end

    def has_struct_metadata?
      can_have_struct_metadata? && structMetadata.has_content?
    end

    def can_have_multires_image?
      respond_to? :multires_image_file_path
    end

    def has_multires_image?
      can_have_multires_image? && multires_image_file_path.present?
    end
    
    def can_have_thumbnail?
      datastreams.key? "thumbnail"
    end

    def has_thumbnail?
      can_have_thumbnail? && thumbnail.has_content?
    end

    def safe_id
      id.sub(/:/, "-")
    end

    # For duck-typing with SolrDocument
    def active_fedora_model
      self.class.to_s
    end

    def controller_name
      active_fedora_model.tableize
    end

    protected

    def has_association? assoc
      !association(assoc).nil?
    end

end
