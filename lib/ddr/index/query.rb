module Ddr::Index
  class Query

    attr_reader :q, :fields, :filters, :sort, :limit

    delegate :count, :docs, :pids, :all, to: :result

    def inspect
      "#<#{self.class.name} q=#{q.inspect}, filters=#{filters.inspect}," \
      " sort=#{sort.inspect}, limit=#{limit.inspect}, fields=#{fields.inspect}>"
    end

    def to_s
      URI.encode_www_form(params)
    end

    def params
      base_params.tap do |p|
        if filters.present?
          p[:fq] = filters.map(&:clauses).flatten
        end
        if sort.present?
          p[:sort] = sort.join(",")
        end
        if limit
          p[:rows] = limit
        end
      end
    end

    def result
      RubyQueryResult.new(self)
    end

    def csv
      CSVQueryResult.new(self)
    end

    private

    def base_params
      { q: q, fl: fields }
    end

  end
end
