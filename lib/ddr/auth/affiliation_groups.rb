module Ddr::Auth
  class AffiliationGroups

    all = []

    Affiliation::ALL.each do |affiliation|
      group = Group.new "duke.#{affiliation}",
                        label: "Duke #{affiliation.capitalize}" do |auth_context|
        auth_context.affiliation.include? affiliation
      end

      const_set affiliation.upcase, group

      all << const_get(affiliation.upcase)
    end

    ALL = all.freeze

  end
end
