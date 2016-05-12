require "forwardable"

module Ddr::Models
  module Validatable

    def self.included(base)
      base.extend Forwardable
      base.def_delegators :validator, :valid?, :invalid?, :errors

      class << base
        attr_accessor :validator
      end
    end

    def validator
      @validator ||= self.class.validator.new(self)
    end

  end
end
