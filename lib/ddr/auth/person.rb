module Ddr
  module Auth
    class Person < Agent
      configure type: RDF::FOAF.Person      

      validates_format_of :name, with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/
    end
  end
end
