module Ddr
  module Auth
    module Roles
      module RoleTypes

        CURATOR = RoleType.new(
          "Curator",
          "The Curator role conveys responsibility for curating a resource " \
          "and delegating responsibilities to other agents.",
          Permissions::ALL
        )

        EDITOR = RoleType.new(
          "Editor",
          "The Editor role conveys reponsibility for managing the content, " \
          "description and structural arrangement of a resource.",
          [ Permissions::READ, Permissions::DOWNLOAD, Permissions::ADD_CHILDREN,
            Permissions::UPDATE, Permissions::REPLACE, Permissions::ARRANGE ]
        )

        METADATA_EDITOR = RoleType.new(
          "MetadataEditor",
          "The Metadata Editor role conveys responsibility for " \
          "managing the description of a resource.",
          [ Permissions::READ, Permissions::DOWNLOAD, Permissions::UPDATE ]
        )

        CONTRIBUTOR = RoleType.new(
          "Contributor",
          "The Contributor role conveys responsibility for adding related " \
          "resources to a resource, such as works to a collection.",
          [ Permissions::READ, Permissions::ADD_CHILDREN ]
        )

        DOWNLOADER = RoleType.new(
          "Downloader",
          "The Downloader role conveys access to the \"master\" file " \
          "(original content bitstream) of a resource.",
          [ Permissions::READ, Permissions::DOWNLOAD ]
        )

        VIEWER = RoleType.new(
          "Viewer",
          "The Viewer role conveys access to the description and \"access\" " \
          "files (e.g., derivative bitstreams) of a resource.",
          [ Permissions::READ ]
        )

      end
    end
  end
end
