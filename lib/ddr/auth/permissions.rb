module Ddr::Auth
  class Permissions
    extend Deprecation

    READ         = :read
    DOWNLOAD     = :download
    ADD_CHILDREN = :add_children
    UPDATE       = :update
    REPLACE      = :replace
    ARRANGE      = :arrange
    PUBLISH      = :publish
    UNPUBLISH    = :unpublish
    AUDIT        = :audit
    GRANT        = :grant

    ALL = [ READ, DOWNLOAD, ADD_CHILDREN, UPDATE, REPLACE, ARRANGE, PUBLISH, UNPUBLISH, AUDIT, GRANT ]

    def self.const_missing(name)
      if name == :EDIT
        Deprecation.warn(self, "`EDIT` is deprecated. Use `UPDATE` instead.")
        return UPDATE
      end
      super
    end

  end
end
