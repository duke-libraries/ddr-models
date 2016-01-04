module Ddr::Jobs
  class UpdateIndex
    extend Job

    @queue = :index

    def self.perform(id)
      obj = ActiveFedora::Base.find(id)
      obj.update_index
    end

  end
end
