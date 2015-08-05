module Ddr::Auth
  class Permissions

    READ         = :read
    DOWNLOAD     = :download
    ADD_CHILDREN = :add_children
    UPDATE       = :update
    REPLACE      = :replace
    ARRANGE      = :arrange
    GRANT        = :grant

    ALL = [ READ, DOWNLOAD, ADD_CHILDREN, UPDATE, REPLACE, ARRANGE, GRANT ]

    def self.const_missing(name)
      if name == :EDIT
        warn "[DEPRECATION] `EDIT` is deprecated. Use `UPDATE` instead."
        return UPDATE
      end
      super
    end

  end
end
