module Ddr::Jobs
  class FitsFileCharacterization
    extend Job

    @queue = :file_characterization

    def self.perform(id)
      obj = ActiveFedora::Base.find(id)
      Ddr::Models::FileCharacterization.call(obj)
    end

  end
end
