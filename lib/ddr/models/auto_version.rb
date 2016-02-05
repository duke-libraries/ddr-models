module Ddr::Models
  module AutoVersion

    def self.extended(base)
      base.include Versionable

      base.class_eval do
        after_save :create_version
      end
    end

  end
end
