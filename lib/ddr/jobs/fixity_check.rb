module Ddr::Jobs
  class FixityCheck
    extend Job

    @queue = :fixity

    def self.perform(id)
      obj = ActiveFedora::Base.find(id)
      obj.fixity_check
    end

  end
end
