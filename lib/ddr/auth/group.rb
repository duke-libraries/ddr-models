module Ddr
  module Auth
    class Group < Agent
      configure type: RDF::FOAF.Group

      validates_format_of :name, with: /\A[\w.:\-]+\z/

      # The inverse of `Ddr::Auth::User#member_of?(group)`
      def has_member?(user)
        user.groups.include?(self)
      end
    end
  end
end
