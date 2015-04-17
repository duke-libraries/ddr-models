module Ddr
  module Auth
    module Roles
      module RoleTypes

        CURATOR = RoleType.new("Curator",
                               "The Curator role conveys responsibility for curating a resource " \
                               "and delegating responsibilities to other agents.",
                               [:read, :download, :add_children, :edit, :replace, :arrange, :grant]
                               )

        EDITOR = RoleType.new("Editor",
                              "The Editor role conveys reponsibility for managing the content, " \
                              "description and structural arrangement of a resource.",
                              [:read, :download, :add_children, :edit, :replace, :arrange]
                              )

        METADATA_EDITOR = RoleType.new("MetadataEditor",
                                       "The Metadata Editor role conveys responsibility for " \
                                       "managing the description of a resource.",
                                       [:read, :download, :edit]
                                       )

        CONTRIBUTOR = RoleType.new("Contributor",
                                   "The Contributor role conveys responsibility for adding related " \
                                   "resources to a resource, such as works to a collection.",
                                   [:read, :add_children]
                                   )
        
        DOWNLOADER = RoleType.new("Downloader",
                                  "The Downloader role conveys access to the \"master\" file " \
                                  "(original content bitstream) of a resource.",
                                  [:read, :download]
                                  )

        VIEWER = RoleType.new("Viewer",
                              "The Viewer role conveys access to the description and \"access\" " \
                              "files (e.g., derivative bitstreams) of a resource.",
                              [:read]
                              )

      end        
    end
  end
end
