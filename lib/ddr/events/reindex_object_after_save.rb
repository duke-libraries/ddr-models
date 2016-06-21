module Ddr
  module Events
    module ReindexObjectAfterSave
      extend ActiveSupport::Concern

      included do
        after_save :reindex_object, if: :pid # in case saved with validate: false
      end

      protected

      def reindex_object
        Resque.enqueue(Ddr::Jobs::UpdateIndex, pid)
      end

    end
  end
end
