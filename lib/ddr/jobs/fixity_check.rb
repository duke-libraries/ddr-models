module Ddr::Jobs
  class FixityCheck
    extend Job

    @queue = :fixity

    def self.perform(id)
      obj = ActiveFedora::Base.find(id)
      obj.check_fixity
    end

  end
end
