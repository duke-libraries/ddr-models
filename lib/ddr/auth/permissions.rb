module Ddr::Auth
  class Permissions

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

  end
end
