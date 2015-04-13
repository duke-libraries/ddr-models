module Ddr
  module Auth
    class Group < Agent

      configure type: RDF::FOAF.Group

      validates_format_of :name, with: /\A[\w.:\-]+\z/

      # The inverse of `Ddr::Auth::User#member_of?(group)`
      def has_member?(user)
        user.groups.include?(self)
      end

      # Override for backward-compatibility with String-based groups
      def method_missing(meth, *args)
        if to_s.respond_to?(meth)
          to_s.send(meth, *args)
        else
          super
        end
      end

    end
  end
end
