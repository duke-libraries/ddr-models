module Ddr
  module Configurable
    extend ActiveSupport::Concern

    included do
      # Base directory of external file store
      mattr_accessor :external_file_store      

      # Regexp for building external file subpath from hex digest
      mattr_accessor :external_file_subpath_regexp
      
      # Pattern (template) for constructing noids
      mattr_accessor :noid_template

      # Noid minter state file location
      mattr_accessor :minter_statefile
    end

    module ClassMethods
      def configure
        yield self
      end

      def external_file_subpath_pattern= (pattern)
        unless /^-{1,2}(\/-{1,2}){0,3}$/ =~ pattern
          raise "Invalid external file subpath pattern: #{pattern}"
        end
        re = pattern.split("/").map { |x| "(\\h{#{x.length}})" }.join("")
        self.external_file_subpath_regexp = Regexp.new("^#{re}")
      end
    end

  end
end
