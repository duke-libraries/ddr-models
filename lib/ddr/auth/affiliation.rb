module Ddr
  module Auth
    class Affiliation < SimpleDelegator

      private_class_method :new

      VALUES = %w( faculty staff student emeritus affiliate alumni ).freeze

      class << self

        def const_missing(name)
          case name
          when :Faculty, :Staff, :Student, :Emeritus, :Affiliate, :Alumni
            warn "[DEPRECATION] `Ddr::Auth::Affiliation::#{name}` is deprecated. " \
                 "Use `Ddr::Auth::Affiliation::#{name.to_s.upcase}` instead."
            const_get(name.to_s.upcase)
          else
            super
          end
        end

        def all
          @all ||= VALUES.map { |value| get(value) }
        end

        # @param affiliation [String, Symbol]
        # @return [Ddr::Auth::Affiliation] or nil
        def get(affiliation_value)
          if VALUES.include?(affiliation_value)
            const_get(affiliation_value.upcase)
          end
        end

        # @param affiliation [String, Symbol]
        # @return [Ddr::Auth::Group] or nil
        def group(affiliation_value)
          if affiliation = get(affiliation_value)
            affiliation.group
          end
        end

        def groups
          @groups ||= all.map(&:group)
        end
        
      end

      attr_reader :group
      
      def initialize(affiliation)
        super
        @group = Group.new "duke.#{self}", label: "Duke #{capitalize}"
        freeze
      end

      def value
        __getobj__
      end

      def inspect
        "#<#{self.class.name} #{value.inspect}>"
      end

      VALUES.each do |value|
        const_set value.upcase, new(value)
      end
      
    end
  end
end
