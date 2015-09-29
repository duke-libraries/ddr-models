module Ddr
  module Jobs
    extend ActiveSupport::Autoload

    autoload :PermanentId
    autoload :FitsFileCharacterization

    autoload_at 'ddr/jobs/permanent_id' do
      autoload :MakeUnavailable
    end
  end
end
