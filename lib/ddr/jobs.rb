module Ddr
  module Jobs
    extend ActiveSupport::Autoload

    autoload :FitsFileCharacterization
    autoload :FixityCheck
    autoload :Job
    autoload :Queue
    autoload :UpdateIndex

  end
end
