module Ddr
  module Jobs
    extend ActiveSupport::Autoload

    autoload :PermanentId

    autoload_at 'ddr/jobs/permanent_id' do
      autoload :MakeUnavailable
    end
  end
end
