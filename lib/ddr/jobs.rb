module Ddr
  module Jobs
    extend ActiveSupport::Autoload

    autoload :FitsFileCharacterization
    autoload :FixityCheck
    autoload :Job
    autoload :PermanentId
    autoload :Queue
    autoload :UpdateIndex

    autoload_at 'ddr/jobs/permanent_id' do
      autoload :MakeUnavailable
    end
  end
end
