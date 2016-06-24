require "forwardable"
require "virtus"

module Ddr::Index
  class Filter
    include Virtus.model

    attribute :clauses, Array, default: [ ]

    def ==(other)
      other.instance_of?(self.class) && (other.clauses == self.clauses)
    end

    module Api
      def raw(*clauses)
        self.clauses += clauses
        self
      end

      def term(conditions)
        self.clauses += conditions.map { |f, v| QueryClause.term(f, v) }
        self
      end

      def where(conditions)
        self.clauses += conditions.map { |f, v| QueryClause.where(f, v) }
        self
      end

      def where_not(conditions)
        self.clauses += conditions.map do |field, v|
          Array(v).map { |value| QueryClause.negative(field, value) }
        end.flatten
      end

      def absent(field)
        self.clauses << QueryClause.absent(field)
        self
      end

      def present(field)
        self.clauses << QueryClause.present(field)
        self
      end

      def negative(field, value)
        self.clauses << QueryClause.negative(field, value)
        self
      end

      def before(field, value)
        self.clauses << QueryClause.before(field, value)
        self
      end

      def before_days(field, value)
        self.clauses << QueryClause.before_days(field, value)
        self
      end

      def join(**args)
        self.clauses << QueryClause.join(**args)
        self
      end
    end

    module ClassMethods
      extend Forwardable

      delegate Api.public_instance_methods => :new_filter

      def has_content
        model "Component", "Attachment", "Target"
      end

      def is_governed_by(object_or_id)
        term is_governed_by: get_id(object_or_id)
      end

      def is_member_of_collection(object_or_id)
        term is_member_of_collection: get_id(object_or_id)
      end

      def is_part_of(object_or_id)
        term is_part_of: get_id(object_or_id)
      end

      def model(*models)
        where active_fedora_model: models
      end

      private

      def get_id(object_or_id)
        object_or_id.respond_to?(:id) ? object_or_id.id : object_or_id
      end

      def new_filter
        Filter.new
      end

    end

    include Api
    extend ClassMethods

  end
end
