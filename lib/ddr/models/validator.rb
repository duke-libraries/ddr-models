require "delegate"

module Ddr::Models
  class Validator < SimpleDelegator
    include ActiveModel::Validations

  end
end
