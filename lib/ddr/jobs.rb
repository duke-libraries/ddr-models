module Ddr
  module Jobs
    extend ActiveSupport::Autoload

    autoload :FitsFileCharacterization
    autoload :Job
    autoload :PermanentId
    autoload :Queue

    autoload_at 'ddr/jobs/permanent_id' do
      autoload :MakeUnavailable
    end
  end
end
