module Ddr::Jobs
  class FitsFileCharacterization
    extend Job

    @queue = :file_characterization

    def self.perform(pid)
      obj = ActiveFedora::Base.find(pid)
      Ddr::Models::FileCharacterization.call(obj)
    end

  end
end
