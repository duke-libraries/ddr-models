module Ddr
  module Auth
    module Groups

      PUBLIC = Group.new "public", label: "Public" do |user|
        true
      end
      
      REGISTERED = Group.new "registered", label: "Registered Users" do |user|
        user.persisted?
      end
      
      DUKE_ALL = Group.new "duke.all", label: "Duke NetIDs" do |user|
        !!(user.to_s =~ /@duke\.edu\z/)
      end
      
      SUPERUSERS = Group.new "ddr.superusers", label: "Superusers" do |user|
        user.context.ismemberof.include? Ddr::Auth.superuser_group
      end
      
      COLLECTION_CREATORS = Group.new "ddr.collection_creators",
                                      label: "Collection Creators" do |user|
        user.context.ismemberof.include? Ddr::Auth.collection_creators_group
      end

      class << self

        def const_missing(name)
          case name
          when :Superusers
            warn "[DEPRECATION] `Ddr::Auth::Groups::Superusers` is deprecated. " \
                 "Use `Ddr::Auth::Groups::SUPERUSERS` instead."
            SUPERUSERS
          when :CollectionCreators
            warn "[DEPRECATION] `Ddr::Auth::Groups::CollectionCreators` is deprecated. " \
                 "Use `Ddr::Auth::Groups::COLLECTION_CREATORS` instead."
            COLLECTION_CREATORS
          when :DUKE_EPPN
            warn "[DEPRECATION] `Ddr::Auth::Groups::DUKE_EPPN` is deprecated. " \
                 "Use `Ddr::Auth::Groups::DUKE_ALL` instead."
            DUKE_ALL
          else
            super
          end
        end

        # Return the list of all groups available for use in the repository,
        #   i.e., that can be used to assert access controls.
        # @return [Array<Group>] the groups
        def all
          [ PUBLIC, REGISTERED, DUKE_ALL, Affiliation.groups, Ddr::Auth.grouper_gateway.repository_groups ].flatten
        end

        # The list of dynamically assigned groups.
        # @return [Array<Group>] the groups
        def dynamic
          [ PUBLIC, REGISTERED, DUKE_ALL, SUPERUSERS, COLLECTION_CREATORS ]
        end

      end

    end
  end
end
