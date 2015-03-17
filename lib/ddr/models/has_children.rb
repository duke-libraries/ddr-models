module Ddr
  module Models
    module HasChildren

      def first_child
        ActiveFedora::Base.where(association_query(:children)).order("#{Ddr::IndexFields::IDENTIFIER} ASC").first
      end

    end
  end
end
